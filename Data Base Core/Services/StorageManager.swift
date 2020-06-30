//
//  StorageManager.swift
//  Data Base Core
//
//  Created by Виталий Сосин on 30.06.2020.
//  Copyright © 2020 Vitalii Sosin. All rights reserved.
//

import CoreData

class StorageManager {
    
    static let shared = StorageManager()
    
    let viewContext = PersistentContainer.shared.viewContext
    
    // MARK: - метод сохранения данных
    func save(_ taskName: String) {
        guard let entityDescription = NSEntityDescription
            .entity(forEntityName: "Task", in: viewContext) else { return }
        guard let task = NSManagedObject(entity: entityDescription, insertInto: viewContext) as? Task else { return }
        task.name = taskName
        
        do {
            try viewContext.save()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    // MARK: - метод получения данных
    func fetchData(tasks: inout [Task]) {
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        
        do {
            tasks = try viewContext.fetch(fetchRequest)
        } catch let error {
            print(error)
        }
    }
    
    // MARK: - метод удаления данных
    func deletData(_ indexPath: IndexPath) {
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        
        if let tasks = try? viewContext.fetch(fetchRequest) {
            viewContext.delete(tasks[indexPath.row])
        }
        
        do {
            try viewContext.save()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    // MARK: - Метод insert
    func insertData(_ indexPath: IndexPath) {
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        
        if let tasks = try? viewContext.fetch(fetchRequest) {
            viewContext.insert(tasks[indexPath.row])
        }
        
        do {
            try viewContext.save()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    private init() {}
}
