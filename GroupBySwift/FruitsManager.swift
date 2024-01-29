//
//  FruitsManager.swift
//  GroupBySwift
//
//  Created by Muhammad Wasiq  on 22/01/2024.
//

import Foundation

class FruitsManager {
    static let shared = FruitsManager()
    private init() {}
    
    var fruits = [FruitModel]()
    
    func addFruitByModifiedDates(fruitModel: FruitModel) {
//        fruits.sort { $0.createdAtDate > $1.createdAtDate }
//        
//        for var fruit in fruits {
//            print(fruit.createdAtDate)
//            let result = areDatesEqual(currentDate: Date(),storedDate: fruit.createdAtDate)
//            if result {
////                print("Today")
//                
//                fruit.dateString = "Today"
//            } else {
//                if let subtractedCurrentDate = Calendar.current.date(byAdding: .day, value: -30, to: Date()) {
//                    if fruit.createdAtDate >= subtractedCurrentDate && fruit.createdAtDate <= Date() {
//                        fruit.dateString = "Previous 30 Days"
//                    } else {
//                        fruit.dateString = getMonth(date: fruit.createdAtDate)
////                        print(fruit.dateString)
//                        
//                    }
//                }
//            }
////            print(fruit)
//            let fruitID = addFruit(fruit: fruit)
////            var fruitsItem = FruitsList(dateString: dateString, list: fruit)
//        }
////        print(fruits.count)
//        print(fruits)
        print(fruitModel.createdAtDate)
        var fruit = fruitModel
//        let result = areDatesEqual(currentDate: Date(),storedDate: fruit.createdAtDate)
//        if result {
//            fruit.dateString = "Today"
//        } else {
//            if let subtractedCurrentDate = Calendar.current.date(byAdding: .day, value: -30, to: Date()) {
//                if fruit.createdAtDate >= subtractedCurrentDate && fruit.createdAtDate <= Date() {
//                    fruit.dateString = "Previous 30 Days"
//                } else {
//                    fruit.dateString = getMonth(date: fruit.createdAtDate)
//                }
//            }
//        }
        let fruitID = addFruit(fruit: fruit)
        let fruitObj = FruitModel(name: fruit.name, color: fruit.color, createdAtDate: fruit.createdAtDate, dateString: fruit.dateString, id: fruitID)
        fruits.append(fruitObj)
    }
    
    func addFruit(fruit: FruitModel) -> UUID {
        let newFruit = Fruits(context: PersistanceStorage.shared.context)
        newFruit.fruitID = UUID()
        newFruit.fruitName = fruit.name
        newFruit.createdAtDate = fruit.createdAtDate
        newFruit.fruitColor = fruit.color
        newFruit.dateString = fruit.dateString
    
        PersistanceStorage.shared.saveContext()
        
        guard let fID = newFruit.fruitID else { return UUID() }
        return fID
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
}
