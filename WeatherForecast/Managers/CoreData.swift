//
//  CoreData.swift
//  WeatherForecast
//
//  Created by Christopher Batin on 13/02/2020.
//  Copyright © 2020 Christopher Batin. All rights reserved.
//

import CoreData

class CoreDataStack {

    static let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "WeatherForecast")
        container.loadPersistentStores { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    static var context: NSManagedObjectContext { return persistentContainer.viewContext }

    static func saveContext() {
        let context = persistentContainer.viewContext
        guard context.hasChanges else {
            return
        }
        do {
            try context.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }

    static func fetchIds() -> [String] {
        var ids = [String]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Locations")
        do {
            let results = try context.fetch(fetchRequest)
            for data in results as? [NSManagedObject] ?? [] {
                ids.append(data.value(forKey: "id") as? String ?? "")
            }
        } catch {
            print("Failed")
        }
        return ids
    }
}
