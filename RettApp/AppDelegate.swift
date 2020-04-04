//
//  AppDelegate.swift
//  RettApp
//
//  Created by Julien Fieschi on 04/04/2020.
//  Copyright © 2020 AFSR. All rights reserved.
//

import UIKit
import CoreData
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: alreadyParticipation Init
    
    var alreadyParticipating:Bool {
        get{
            return UserDefaults.standard.bool(forKey: "UserHasConsentedKey")
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "UserHasConsentedKey")
            UserDefaults.standard.synchronize()
        }
    }
    
    func getPlist(withName name: String) -> [String]?
    {
        if  let path = Bundle.main.path(forResource: name, ofType: "plist"),
            let xml = FileManager.default.contents(atPath: path)
        {
            return (try? PropertyListSerialization.propertyList(from: xml, options: .mutableContainersAndLeaves, format: nil)) as? [String]
        }

        return nil
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        if UserDefaults.standard.value(forKey: "Device_uuid") == nil {
            UserDefaults.standard.set(UUID().uuidString, forKey: "Device_uuid")
        }
        
        print("UUID de l'appareil: ", UserDefaults.standard.value(forKey: "Device_uuid") as! String )
        
        if let path = Bundle.main.path(forResource: "AFSR_Credentials", ofType: "plist"), let dict_Credentials = NSDictionary(contentsOfFile: path) as? [String: AnyObject] {
                // use swift dictionary as normal
                let configuration = ParseClientConfiguration {
                    $0.applicationId = dict_Credentials["appId"] as! String
                    $0.clientKey = dict_Credentials["clientKey"] as! String
                    $0.server =  dict_Credentials["server"] as! String
                }
              
            
            Parse.initialize(with: configuration)
        }
        
        let gameScore = PFObject(className:"GameScore")
        gameScore["score"] = 1337
        gameScore["playerName"] = "Sean Plott"
        gameScore["cheatMode"] = false
        gameScore.saveInBackground { (succeeded, error)  in
            if (succeeded) {
                // The object has been saved.
                print("Success!")
            } else {
                // There was a problem, check error.description
                print("Failed!")
            }
        }
                
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentCloudKitContainer(name: "RettApp")
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

