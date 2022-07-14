//
//  UserEntity+CoreDataProperties.swift
//  VKApp
//
//  Created by Artemiy Zuzin on 10.07.2022.
//
//

import Foundation
import CoreData


extension UserEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserEntity> {
        return NSFetchRequest<UserEntity>(entityName: "UserEntity")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var image: Data?
    @NSManaged public var date: Date?
    @NSManaged public var name: String?
    @NSManaged public var work: String?

}

extension UserEntity : Identifiable {

}
