//
//  Persistence.swift
//  CoreDataExample
//
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    //MARK: - If you do not want to use iCloud
//    let container: NSPersistentContainer
    
    //MARK: - If you want to use iCloud
    let container: NSPersistentCloudKitContainer
    
    init(inMemory: Bool = false) {
//        container = NSPersistentContainer(name: "CoreDataExample")
        container = NSPersistentCloudKitContainer(name: "CoreDataExample")
        
        container.persistentStoreDescriptions.first!.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
        container.persistentStoreDescriptions.first!.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.automaticallyMergesChangesFromParent = true
        
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
//                fatalError("Unresolved error \(error), \(error.userInfo)")
                print("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}


