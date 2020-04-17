//
//  CDMediaObject+CoreDataProperties.swift
//  AVFoundationProject
//
//  Created by Ahad Islam on 4/16/20.
//  Copyright © 2020 Ahad Islam. All rights reserved.
//
//

import Foundation
import CoreData


extension CDMediaObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDMediaObject> {
        return NSFetchRequest<CDMediaObject>(entityName: "CDMediaObject")
    }

    @NSManaged public var date: Date?
    @NSManaged public var id: String?
    @NSManaged public var imageData: Data?
    @NSManaged public var videoData: Data?

}
