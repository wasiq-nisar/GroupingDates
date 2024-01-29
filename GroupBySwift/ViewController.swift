//
//  ViewController.swift
//  GroupBySwift
//
//  Created by Muhammad Wasiq  on 17/01/2024.
//

import UIKit
import CoreData

class ViewController: UIViewController, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var fruits = [FruitModel]()
    var newFruits: [Fruits]?
    var groupedData: [String: [Fruits]] = [:]
    var sectionNames = [String]()
    var fetchedResultsController: NSFetchedResultsController<Fruits>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let currentDate = Date()
        
        let fruit1 = FruitModel(name: "Apple", color: "Red", createdAtDate: currentDate)
        let fruit2 = FruitModel(name: "Apple2", color: "Red", createdAtDate: dateFormatter.date(from: "01/01/2024") ?? Date())
        let fruit3 = FruitModel(name: "Apple3", color: "Purple", createdAtDate: dateFormatter.date(from: "05/01/2023") ?? Date())
        let fruit4 = FruitModel(name: "Banana", color: "Yellow",createdAtDate: dateFormatter.date(from: "02/03/2023") ?? Date())
        let fruit5 = FruitModel(name: "Apple", color: "Green",createdAtDate: dateFormatter.date(from: "03/11/2023") ?? Date())
        let fruit12 = FruitModel(name: "Apple", color: "Green",createdAtDate: dateFormatter.date(from: "07/11/2023") ?? Date())
        let fruit6 = FruitModel(name: "Orange", color: "Orange",createdAtDate: dateFormatter.date(from: "27/10/2023") ?? Date())
        let fruit7 = FruitModel(name: "Grapes", color: "Purple", createdAtDate: currentDate)
        let fruit8 = FruitModel(name: "Grapes7", color: "Green",createdAtDate: dateFormatter.date(from: "27/7/2023") ?? Date())
        let fruit9 = FruitModel(name: "Grapes6", color: "Green",createdAtDate: dateFormatter.date(from: "27/6/2023") ?? Date())
        let fruit10 = FruitModel(name: "Grapes5", color: "Green",createdAtDate: dateFormatter.date(from: "27/5/2023") ?? Date())
        let fruit11 = FruitModel(name: "Grapes4", color: "Green",createdAtDate: dateFormatter.date(from: "27/4/2023") ?? Date())
        let fruit13 = FruitModel(name: "Grapes4", color: "Green",createdAtDate: dateFormatter.date(from: "27/4/2022") ?? Date())
        

        FruitsManager.shared.addFruitByModifiedDates(fruitModel: fruit1)
        FruitsManager.shared.addFruitByModifiedDates(fruitModel: fruit2)
        FruitsManager.shared.addFruitByModifiedDates(fruitModel: fruit3)
        FruitsManager.shared.addFruitByModifiedDates(fruitModel: fruit4)
        FruitsManager.shared.addFruitByModifiedDates(fruitModel: fruit5)
        FruitsManager.shared.addFruitByModifiedDates(fruitModel: fruit6)
        FruitsManager.shared.addFruitByModifiedDates(fruitModel: fruit10)
        FruitsManager.shared.addFruitByModifiedDates(fruitModel: fruit11)
        FruitsManager.shared.addFruitByModifiedDates(fruitModel: fruit7)
        FruitsManager.shared.addFruitByModifiedDates(fruitModel: fruit8)
        FruitsManager.shared.addFruitByModifiedDates(fruitModel: fruit9)
        FruitsManager.shared.addFruitByModifiedDates(fruitModel: fruit12)
        FruitsManager.shared.addFruitByModifiedDates(fruitModel: fruit13)
        
        
        fetchFruitsInGroups()
        newFruits = fetchedResultsController.fetchedObjects
        print("<--------------->")
        if let newFruits = newFruits {
            for newFruit in newFruits {
                let result = areDatesEqual(currentDate: Date(),storedDate: newFruit.createdAtDate)
                if result {
                    if groupedData["Today"] == nil {
                        groupedData["Today"] = [newFruit]
                        sectionNames.append("Today")
                    } else {
                        groupedData["Today"]?.append(newFruit)
                    }
                } else {
                    if let subtractedCurrentDate = Calendar.current.date(byAdding: .day, value: -30, to: Date()) {
                        if newFruit.createdAtDate! >= subtractedCurrentDate && newFruit.createdAtDate! <= Date() {
                            if groupedData["Previous 30 Days"] == nil {
                                groupedData["Previous 30 Days"] = [newFruit]
                                sectionNames.append("Previous 30 Days")
                            } else {
                                groupedData["Previous 30 Days"]?.append(newFruit)
                            }
                        } else {
                            if let yearOfStoredDate = getYear(storedDate: newFruit.createdAtDate) {
                                let yearOfStoredDateString = String(yearOfStoredDate)
                                let currentYear = getYear(storedDate: Date())
                                if currentYear == yearOfStoredDate {
                                    if groupedData[getMonth(date: newFruit.createdAtDate!)] == nil {
                                        groupedData[getMonth(date: newFruit.createdAtDate!)] = [newFruit]
                                        sectionNames.append(getMonth(date: newFruit.createdAtDate!))
                                    } else {
                                        groupedData[getMonth(date: newFruit.createdAtDate!)]?.append(newFruit)
                                    }
                                } else {
                                    if groupedData[yearOfStoredDateString] == nil {
                                        sectionNames.append(yearOfStoredDateString)
                                        groupedData[yearOfStoredDateString] = [newFruit]
                                    } else {
                                        groupedData[yearOfStoredDateString]?.append(newFruit)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        print(sectionNames)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: TableViewCell.identifier, bundle: nil), forCellReuseIdentifier: TableViewCell.identifier)
        tableView.reloadData()
    }
    
    func fetchFruits() {
        let context = PersistanceStorage.shared.context
        do {
            let request: NSFetchRequest<Fruits> = Fruits.fetchRequest()
            let entities = try context.fetch(request)
            
            fruits = entities.compactMap { entity in
                guard let name = entity.fruitName,
                   let color = entity.fruitColor,
                      let createdAtDate = entity.createdAtDate,
                      let dateString = entity.dateString,
                   let id = entity.fruitID else { return nil }
                return FruitModel(name: name, color: color, createdAtDate: createdAtDate, dateString: dateString, id: id)
            }
        }
        catch {
            debugPrint(error)
        }
    }
    
    func fetchFruitsInGroups() {
        let context = PersistanceStorage.shared.context
        let request: NSFetchRequest<Fruits> = Fruits.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: "createdAtDate", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: "createdAtDate",
            cacheName: nil
        )
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Error fetching data: \(error.localizedDescription)")
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath) as? TableViewCell else { return UITableViewCell() }
        
//        newFruits = fetchedResultsController.object(at: indexPath)
        cell.title.text = groupedData[sectionNames[indexPath.section]]?[indexPath.row].createdAtDate?.description
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionNames.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupedData[sectionNames[section]]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionNames[section]
    }
    
    func getMonth(date: Date) -> String {
        let components = Calendar.current.dateComponents([.month], from: date)
        switch components.month {
        case 1:
            return "January"
        case 2:
            return "Febuary"
        case 3:
            return "March"
        case 4:
            return "April"
        case 5:
            return "May"
        case 6:
            return "June"
        case 7:
            return "July"
        case 8:
            return "August"
        case 9:
            return "September"
        case 10:
            return "October"
        case 11:
            return "November"
        case 12:
            return "December"
        default:
            print("Can Not get Month")
            return ""
        }
    }
    
    func areDatesEqual(currentDate: Date?, storedDate: String) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        
        if let currentDate = currentDate, let storedDate = dateFormatter.date(from: storedDate) {
            let calendar = Calendar.current
            let componentsCurrent = calendar.dateComponents([.year, .month, .day], from: currentDate)
            let componentsStored = calendar.dateComponents([.year, .month, .day], from: storedDate)
            return componentsCurrent.year == componentsStored.year &&
                   componentsCurrent.month == componentsStored.month &&
                   componentsCurrent.day == componentsStored.day
        }
        return false
    }
    
    func subtract30Days(from dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"

        if let date = dateFormatter.date(from: dateString) {
            let calendar = Calendar.current
            if let subtractedDate = calendar.date(byAdding: .day, value: -30, to: date) {
                return subtractedDate
            }
        }
        return nil
    }
    
    func convertToDate(dateString: String) -> Date? {
        let inputDateFormatter = DateFormatter()
        inputDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"

        if let date = inputDateFormatter.date(from: dateString) {
            let outputDateFormatter = DateFormatter()
            outputDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
            let formattedDateString = outputDateFormatter.string(from: date)
            return outputDateFormatter.date(from: formattedDateString)
        } else {
            return nil  // Unable to convert string to date
        }
    }
    
    func areDatesEqual(currentDate: Date?, storedDate: Date?) -> Bool {
        if let currentDate = currentDate, let storedDate = storedDate {
            let calendar = Calendar.current
            let componentsCurrent = calendar.dateComponents([.year, .month, .day], from: currentDate)
            let componentsStored = calendar.dateComponents([.year, .month, .day], from: storedDate)
            return componentsCurrent.year == componentsStored.year &&
                   componentsCurrent.month == componentsStored.month &&
                   componentsCurrent.day == componentsStored.day
        }
        return false
    }
    
    func getYear(storedDate: Date?) -> Int? {
        if let storedDate = storedDate {
            let calendar = Calendar.current
            let componentsStored = calendar.dateComponents([.year], from: storedDate)
            return componentsStored.year
        }
        return nil
    }
}
