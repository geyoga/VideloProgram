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
    var techniqueCounter: Int32 = 0
    var lessonCounter: Int32 = 0
    
    func addTechnique(name: String, icon: String) -> Techniques {
        //TECHNIQUE
        techniqueCounter += 1
        
        let technique = Techniques(context: CoreDataHelper.managedContext)
        technique.id = techniqueCounter
        technique.name = name
        technique.icon = icon
        CoreDataHelper.save()
        return technique
    }
    
    func addLesson(name: String, type: String, shortDesc: String, longDesc: String, objectName: String, learn_use: NSSet, image: String) {
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
}
