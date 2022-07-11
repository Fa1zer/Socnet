//
//  PostEntity+CoreDataProperties.swift
//  VKApp
//
//  Created by Artemiy Zuzin on 10.07.2022.
//
//

import Foundation
import CoreData


extension PostEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PostEntity> {
        return NSFetchRequest<PostEntity>(entityName: "PostEntity")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var userID: UUID?
    @NSManaged public var userImage: Data?
    @NSManaged public var image: Data?
    @NSManaged public var userName: String?
    @NSManaged public var text: String?
    @NSManaged public var likes: Int32
    @NSManaged public var date: Date?

}

extension PostEntity : Identifiable {

}
