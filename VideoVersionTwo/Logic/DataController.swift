//
//  DataController.swift
//  VideoVersionTwo
//
//  Created by Indra Sumawi on 17/07/19.
//  Copyright © 2019 Georgius Yoga Dewantama. All rights reserved.
//

import Foundation
import CoreData

class DataController {
    static var techniqueCounter: Int32 = 0
    static var lessonCounter: Int32 = 0
    
    static func addTechnique(name: String, icon: String) -> Techniques {
        //TECHNIQUE
        techniqueCounter += 1
        
        let technique = Techniques(context: CoreDataHelper.managedContext)
        technique.id = techniqueCounter
        technique.name = name
        technique.icon = icon
        CoreDataHelper.save()
        return technique
    }
    
    static func addLesson(name: String, type: String, shortDesc: String, longDesc: String, objectName: String, learn_use: NSOrderedSet, image: String) {
        lessonCounter += 1
        let lesson1 = Lessons(context: CoreDataHelper.managedContext)
        lesson1.id = lessonCounter
        lesson1.name = name
        lesson1.type = type
        lesson1.shortDesc = shortDesc
        lesson1.longDesc = longDesc
        lesson1.objectName = objectName
        lesson1.addToLearn_use(learn_use)
        lesson1.image = image
        CoreDataHelper.save()
    }
    
    /*
     always return nil after close the  app
     static func addHistory(technique: Techniques, lesson: Lessons)  {
        let history = History_technique(context: CoreDataHelper.managedContext)
        history.lesson = lesson.self
        history.technique = technique.self
        history.timestamp = Date()
        CoreDataHelper.save()
    }*/
    
    static func addHistory(techniqueName: String)  {
        let history = History_technique(context: CoreDataHelper.managedContext)
        history.techniqueName = techniqueName
        history.timestamp = Date()
        CoreDataHelper.save()
    }
    
}
