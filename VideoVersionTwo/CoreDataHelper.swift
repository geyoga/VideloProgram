//
//  CoreDataHelper.swift
//  HandsOnExerciseLocalData
//
//  Created by Indra Sumawi on 02/07/19.
//  Copyright © 2019 Indra Sumawi. All rights reserved.
//

/*
 HOW TO USE
 //clear all
 let data = CoreDataHelper.fetch(entity: "Lesson") as [Lesson]
 for les in data {
 CoreDataHelper.delete(data: les)
 }
 
 let lesson = Lesson(context: CoreDataHelper.managedContext)
 lesson.id = Int32.random(in: 1...100)
 lesson.name = "Lesson"
 
 CoreDataHelper.save()
 
 let less = CoreDataHelper.fetch(entity: "Lesson") as [Lesson]
 for les in less {
 print("\(les.id) - \(lesson.name)")
 }*/


import Foundation
import UIKit
import CoreData

class CoreDataHelper {
    init() {
        
    }
    
    static let managedContext: NSManagedObjectContext = {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError()
        }
        
        let persistentContainer = appDelegate.persistentContainer
        let context = persistentContainer.viewContext
        
        return context
    }()
    
    //parameters depends on the one that you want to save
    //can make it generic
    
    static func save() {
        //commit
        do {
            try CoreDataHelper.managedContext.save()
            print("Data Saved")
        }
        catch {
            print("Error")
        }
    }
    
    //return statement depends on what data to fetch
    //can make it generic
    static func fetch<T>(entity: String)  -> [T] {
        var result: [T] = []

        let  request =  NSFetchRequest<NSFetchRequestResult>(entityName: entity)
    
        do {
            result = try CoreDataHelper.managedContext.fetch(request) as! [T]
            print("success")
        }
        catch {
            result = []
            print("error")
        }
        return result
    }
    
    static func delete<T>(data: T) {
        CoreDataHelper.managedContext.delete(data as! NSManagedObject)
        save()
    }
}
