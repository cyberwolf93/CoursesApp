//
//  AppDatabaseManager.swift
//  AppDataBase
//
//  Created by Ahmed Mohiy on 26/01/2023.
//

import Foundation
import CoreData

class AppDatabaseManager {

    //MARK: - Variables
    static let `default`: AppDatabaseManager = AppDatabaseManager()
    var persistentContainer: NSPersistentContainer!
    
    init() {
        let modelURL = Bundle(identifier: "com.amohiy.photographyschoollessonapp.database.AppDataBase")!.url(forResource: "AppDataBaseModel", withExtension: "momd")!
        let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL)!
        let container = NSPersistentContainer(name: "AppDataBaseModel", managedObjectModel: managedObjectModel)
        container.loadPersistentStores { storeDescription, error in
            if let error = error as? NSError {
                fatalError("load database err: \(error), userInfo: \(error.userInfo)")
            }
        }
        
        persistentContainer = container
    }
    
    //MARK: Save to data base
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("save database error: \(error)")
            }
        }
    }
}
