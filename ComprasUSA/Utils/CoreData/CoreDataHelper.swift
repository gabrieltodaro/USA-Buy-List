//
//  CoreDataStack.swift
//  ComprasUSA
//
//  Created by Gabriel Patane Todaro on 28/03/23.
//

import CoreData
import Foundation

class CoreDataHelper {
  private let modelName: String

  init(modelName: String) {
    self.modelName = modelName
  }

  private lazy var persistentContainer: NSPersistentContainer = {
    /*
     The persistent container for the application. This implementation
     creates and returns a container, having loaded the store for the
     application to it. This property is optional since there are legitimate
     error conditions that could cause the creation of the store to fail.
     */

    let container = NSPersistentContainer(name: self.modelName)
    container.loadPersistentStores { storeDescription, error in
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
        print("Unresolved error \(error), \(error.userInfo)")
      }
    }
    return container
  }()

  lazy var managedContext: NSManagedObjectContext = self.persistentContainer.viewContext

  func saveContext() {
    guard managedContext.hasChanges else { return }

    do {
      try managedContext.save()
    } catch let error as NSError {
      print("Unresolved error \(error), \(error.userInfo)")
    }
  }
}
