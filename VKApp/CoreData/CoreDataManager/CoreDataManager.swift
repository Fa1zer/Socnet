//
//  CoreDataManager.swift
//  VKApp
//
//  Created by Artemiy Zuzin on 04.07.2022.
//

import Foundation
import CoreData
import UIKit

final class CoreDataManager: NSObject {
    
    var tableView: UITableView?
    
    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "PostModel")
        
        container.loadPersistentStores { storeDescription, error in
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
        }
        
        return container
    }()
    
    private let fetchedResultController: NSFetchedResultsController<PostEntity> = {
        let request = NSFetchRequest<PostEntity>(entityName: "PostEntitie")
        let sort = NSSortDescriptor(key: "date", ascending: true)
        let container = NSPersistentContainer(name: "PostModel")

        container.loadPersistentStores { storeDescription, error in
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
        }

        request.sortDescriptors = [sort]
        request.fetchBatchSize = 20
        
        return NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: container.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
    }()
    
    func getPosts(didComplete: @escaping ([PostEntity]) -> Void) {
        let context = self.persistentContainer.viewContext
        let fetchRequest = PostEntity.fetchRequest()
        
        context.perform { [ weak self ] in
            do {
                try self?.fetchedResultController.performFetch()
                
                didComplete(try context.fetch(fetchRequest))
                
                self?.tableView?.reloadData()
            } catch {
                print(error.localizedDescription)
                
                didComplete([])
            }
        }
    }
    
    func deletePost(postEntity: PostEntity, didComplete: @escaping () -> Void) {
        let context = self.persistentContainer.viewContext
        let fetchRequest = PostEntity.fetchRequest()
        
        context.perform { [ weak self ] in
            do {
                try self?.fetchedResultController.performFetch()
                
                for post in try context.fetch(fetchRequest) {
                    if postEntity.id == post.id {
                        context.delete(postEntity as NSManagedObject)
                        
                        break
                    }
                }
                                
                try context.save()
                
                didComplete()
            } catch {
                print(error.localizedDescription)
                
                return
            }
        }
    }
    
    func save(post: Post, user: User) {
        let context = self.persistentContainer.newBackgroundContext()
        
        guard let entity = NSEntityDescription.entity(forEntityName: "PostEntity", in: context) else {
            return
        }
        
        let postEntity = PostEntity(entity: entity, insertInto: context)
        
        postEntity.userID = user.id
        postEntity.id = post.id
        postEntity.text = post.text
        postEntity.likes = Int32(post.likes)
        postEntity.image = Data(base64Encoded: post.image)
        postEntity.userImage = Data(base64Encoded: user.image ?? (UIImage(named: "empty avatar")?.pngData()?.base64EncodedString() ?? ""))
        postEntity.userName = user.name
        postEntity.date = Date()
        
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
            
            return
        }
    }
    
}

extension CoreDataManager: NSFetchedResultsControllerDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.fetchedResultController.sections?.count ?? 0
    }

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView?.beginUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {

        switch type {
        case .insert:

            guard let newIndexPath = newIndexPath else {
                return
            }

            self.tableView?.insertRows(at: [newIndexPath], with: .automatic)

        case .delete:

            guard let indexPath = indexPath else {
                return
            }

            self.tableView?.deleteRows(at: [indexPath], with: .automatic)

        case .move:

            guard let newIndexPath = newIndexPath, let indexPath = indexPath else {
                return
            }

            self.tableView?.moveRow(at: indexPath, to: newIndexPath)

        case .update:

            guard let indexPath = indexPath else {
                return
            }

            self.tableView?.reloadRows(at: [indexPath], with: .automatic)

        @unknown default:
            fatalError()
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView?.endUpdates()
    }
    
}
