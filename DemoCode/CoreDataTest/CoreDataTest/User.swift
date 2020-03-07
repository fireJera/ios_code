//
//  User.swift
//  CoreDataTest
//
//  Created by Jeremy on 2019/1/21.
//  Copyright © 2019 JersiZhu. All rights reserved.
//

import UIKit
import CoreData

import UIKit
import CoreData

@objc(Travel)
class Travel: NSManagedObject {
    
}

extension Travel {
    @nonobjc
    public class
        func fetchRequest() -> NSFetchRequest<Travel> {
        return NSFetchRequest<Travel>(entityName: "Travel")
    }
    @NSManaged
    public var destination: String?
    @NSManaged
    public var startTime: Date?
    @NSManaged
    public var endTime: Date?
    
}
