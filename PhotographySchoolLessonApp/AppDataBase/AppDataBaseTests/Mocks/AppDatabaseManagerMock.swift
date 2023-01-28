//
//  AppDatabaseManagerMock.swift
//  AppDataBaseTests
//
//  Created by Ahmed Mohiy on 28/01/2023.
//

@testable import AppDataBase
import CoreData
import Foundation

class AppDatabaseManagerMock: AppDatabaseManager {
    
    override init() {
        super.init()
        let persistentStoreDescription = NSPersistentStoreDescription()
            persistentStoreDescription.type = NSInMemoryStoreType
        
        let modelURL = Bundle(identifier: "com.amohiy.photographyschoollessonapp.database.AppDataBase")!.url(forResource: "AppDataBaseModel", withExtension: "momd")!
        let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL)!
        let container = NSPersistentContainer(name: "AppDataBaseModel", managedObjectModel: managedObjectModel)
        container.persistentStoreDescriptions = [persistentStoreDescription]
        
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("load database err: \(error), userInfo: \(error.userInfo)")
            }
        }
        
        self.persistentContainer = container
    }
}
