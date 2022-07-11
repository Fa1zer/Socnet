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
    var collectionView: UICollectionView?
    var callBack: (() -> Void)?
    var secondCallBack: (() -> Void)?
    
    private let postPersistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataPostModel")
        
        container.loadPersistentStores { storeDescription, error in
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
        }
        
        return container
    }()
    
    private let userPersistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "UserModel")
        
        container.loadPersistentStores { storeDescription, error in
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
        }
        
        return container
    }()
    
    private let postFetchedResultController: NSFetchedResultsController<PostEntity> = {
        let request = NSFetchRequest<PostEntity>(entityName: "PostEntity")
        let sort = NSSortDescriptor(key: "date", ascending: true)
        let container = NSPersistentContainer(name: "CoreDataPostModel")

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
    
    private let userFetchedResultController: NSFetchedResultsController<UserEntity> = {
        let request = NSFetchRequest<UserEntity>(entityName: "UserEntity")
        let sort = NSSortDescriptor(key: "date", ascending: true)
        let container = NSPersistentContainer(name: "UserModel")

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
        let context = self.postPersistentContainer.viewContext
        let fetchRequest = PostEntity.fetchRequest()
        
        context.perform { [ weak self ] in
            do {
                try self?.postFetchedResultController.performFetch()
                
                didComplete(try context.fetch(fetchRequest))
                
                self?.tableView?.reloadData()
            } catch {
                print(error.localizedDescription)
                
                didComplete([])
            }
        }
    }
    
    func deletePost(post: Post, didComplete: @escaping () -> Void) {
        let context = self.postPersistentContainer.viewContext
        let fetchRequest = PostEntity.fetchRequest()
        
        context.perform { [ weak self ] in
            do {
                try self?.postFetchedResultController.performFetch()
                
                for post in try context.fetch(fetchRequest) {
                    if post.id == post.id {
                        context.delete(post as NSManagedObject)
                        
                        break
                    }
                }
                                
                try context.save()
                
                didComplete()
                
                self?.callBack?()
                self?.tableView?.reloadData()
            } catch {
                print(error.localizedDescription)
                
                return
            }
        }
    }
    
    func savePost(post: Post, user: User) {
        let context = self.postPersistentContainer.newBackgroundContext()
        
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
            
            self.callBack?()
            self.tableView?.reloadData()
        } catch {
            print(error.localizedDescription)
            
            return
        }
    }
    
    func getUsers(didComplete: @escaping ([UserEntity]) -> Void) {
        let context = self.userPersistentContainer.viewContext
        let fetchRequest = UserEntity.fetchRequest()
        
        context.perform { [ weak self ] in
            do {
                try self?.userFetchedResultController.performFetch()
                
                didComplete(try context.fetch(fetchRequest))
                
                self?.collectionView?.reloadData()
            } catch {
                print(error.localizedDescription)
                
                didComplete([])
            }
        }
    }
    
    func deleteUser(user: User, didComplete: @escaping () -> Void) {
        let context = self.userPersistentContainer.viewContext
        let fetchRequest = UserEntity.fetchRequest()
        
        context.perform { [ weak self ] in
            do {
                try self?.userFetchedResultController.performFetch()
                
                for user in try context.fetch(fetchRequest) {
                    if user.id == user.id {
                        context.delete(user as NSManagedObject)
                        
                        break
                    }
                }
                                
                try context.save()
                
                didComplete()
                
                self?.secondCallBack?()
                self?.collectionView?.reloadSections(IndexSet(integer: 0))
            } catch {
                print(error.localizedDescription)
                
                return
            }
        }
    }
    
    func saveUser(user: User) {
        let context = self.userPersistentContainer.newBackgroundContext()
        
        guard let entity = NSEntityDescription.entity(forEntityName: "UserEntity", in: context) else {
            return
        }
        
        let userEntity = UserEntity(entity: entity, insertInto: context)
        
        userEntity.id = user.id
        userEntity.date = Date()
        userEntity.image = Data(base64Encoded: user.image ?? "")
        
        do {
            try context.save()
            
            self.secondCallBack?()
            self.collectionView?.reloadSections(IndexSet(integer: 0))
        } catch {
            print(error.localizedDescription)
            
            return
        }
    }
    
}

extension CoreDataManager: NSFetchedResultsControllerDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.postFetchedResultController.sections?.count ?? 0
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
