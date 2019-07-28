//
//  AppDelegate.swift
//  VideoVersionTwo
//
//  Created by Georgius Yoga Dewantama on 11/07/19.
//  Copyright © 2019 Georgius Yoga Dewantama. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UITabBar.appearance().tintColor = .orange
        UITabBar.appearance().barTintColor = .black
        // Override point for customization after application launch.
        
        initData()
        //check state first time
        //to remove state
        //UserDefaults.standard.removeObject(forKey: "isFirstTime")
        if UserDefaults.standard.object(forKey: "isFirstTime") != nil {
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let nextViewController = storyboard.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
            self.window?.rootViewController = nextViewController
        }
        
        return true
    }
    
    func initData() {
        //CLEAR ALL
        /*let datas = CoreDataHelper.fetch(entity: "Lessons") as [Lessons]
         for item in datas {
         for technique in item.learn_use!.array {
         CoreDataHelper.delete(data: technique)
         }
         CoreDataHelper.delete(data: item)
         }
         
         /*let history = CoreDataHelper.fetch(entity: "History_technique") as [History_technique]
         for item in history {
         CoreDataHelper.delete(data: item)
         }*/
         */
        let datas = CoreDataHelper.fetch(entity: "Lessons") as [Lessons]
        
        if (datas.count == 0) {
            print("CREATE")
            //MOVEMENT
            let pan = DataController.addTechnique(name: "Pan", icon: "Pan Symbol")
            let tilt = DataController.addTechnique(name: "Tilt", icon: "Tilt Symbol")
            let dolly = DataController.addTechnique(name: "Dolly", icon: "Dolly In Symbol")
            let tracking = DataController.addTechnique(name: "Tracking", icon: "Tracking Symbol")
            
            var learn_use = NSOrderedSet.init(array: [pan, dolly])
            
            DataController.addLesson(name: "Tutorial", type: "Tutorial", shortDesc: "Tutorial", longDesc:
                """
                In this Tutorial, You will do some Practice in order to know about our Apps. There will be some Instructions how to use our App and you must follow the instructions. Find the surface and there will be spawned model in front of your phone. Then, you will follow the object and reach some checkpoint until you finish the Tutorial. After you finish the Tutorial, there will be unlocked Lesson incoming for you!
                """
                , objectName: "tong.scn", learn_use: learn_use, image: "Tutorial Background")
            
            learn_use = NSOrderedSet.init(array: [pan, tilt, dolly, tracking])
            DataController.addLesson(name: "Introduction to Movement", type: "Lesson", shortDesc: "Movement", longDesc: """
            Camera movement has powerful impact in videography, such as to direct the viewer's attention, provide narrative information, or create expressive effects. You will practice your skills in Movement Techniques, such as Dolly in technique, Tilt technique, Pan Technique, and Tracking Technique. You must do all the Instruction in order to complete Movement Technique.
            """, objectName: "Walking copy 2.scn", learn_use: learn_use, image: "Fund_Movement")
            
            //ANGLE
            let high = DataController.addTechnique(name: "High Angle", icon: "High Angle Symbol")
            let low = DataController.addTechnique(name: "Low Angle", icon: "Low Angle Symbol")
            
            learn_use = NSOrderedSet.init(array: [high, low])
            DataController.addLesson(name: "Introduction to Angle", type: "Lesson", shortDesc: "Angle", longDesc: """
                The angle in videography have a big effect on what the picture tells the audience and really important for shaping the meaning of the video. You will practice 2 Angle Techniques, High Angle Techniques and Low Angle Technique. You must follow the instruction to complete the Angle Lesson.
                """, objectName: "buildingWithBarrel.scn", learn_use: learn_use, image: "Fund_Angle")
            
            //SHOT
            let closeUp = DataController.addTechnique(name: "Close Up Shot", icon: "Close Up Symbol")
            let medium = DataController.addTechnique(name: "Medium Shot", icon: "Medium Shot Symbol")
            
            learn_use = NSOrderedSet.init(array: [closeUp, medium])
            DataController.addLesson(name: "Introduction to Shot", type: "Lesson", shortDesc: "Shot", longDesc: """
            The shots can affect your scene, so you can make your shots work together to form a beautiful, clear, and cohesive narrative. You will learn 2 Shot Techniques, Close Up Shot and Medium shot. You must do all the instruction in order to complete Shot Lesson.
            
            """, objectName: "humanStill.scn", learn_use: learn_use, image: "Fund_Shot")
            
            //exercise 1
            learn_use = NSOrderedSet.init(array: [tracking, high, dolly])//[pan, tracking, dolly, closeUp])
            DataController.addLesson(name: "Circle the Object", type: "Course", shortDesc: "You will learn a lot", longDesc: "You will learn a lot", objectName: "plant.scn", learn_use: learn_use, image: "Exe_StillObject")
        }
        //FETCH
        let data = CoreDataHelper.fetch(entity: "Lessons") as [Lessons]
        for item in data {
            print("\(item.id) - \(String(describing: item.name)) - \(String(describing: item.type)) - \(String(describing: item.shortDesc)) - \(String(describing: item.longDesc)) - \(String(describing: item.objectName))")
            for case let technique as Techniques in item.learn_use! {
                print("\(technique.id) - \(String(describing: technique.name))")
            }
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "VideoVersionTwo")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

