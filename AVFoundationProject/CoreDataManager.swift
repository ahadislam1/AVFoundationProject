//
//  CoreDataManager.swift
//  avfoundation-mediafeed
//
//  Created by Ahad Islam on 4/15/20.
//  Copyright © 2020 Ahad Islam. All rights reserved.
//

import UIKit
import CoreData

class CoreDataManager {
    private init() {}
    static let shared = CoreDataManager()
    
    private var mediaObjects = [CDMediaObject]()
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func createMediaObject(_ imageData: Data, videoURL: URL?) -> CDMediaObject {
        let mediaObject = CDMediaObject(entity: CDMediaObject.entity(), insertInto: context)
        
        
        mediaObject.date = Date()
        mediaObject.id = UUID().uuidString
        mediaObject.imageData = imageData
        if let videoURL = videoURL {
            do {
            mediaObject.videoData = try Data(contentsOf: videoURL)
            } catch {
                print("failed to convert URL to Data with error: \(error)")
            }
        }
        
        do {
            try context.save()
        } catch {
            print("failed to save newly created media object with error: \(error)")
        }
        return mediaObject
    }
    
    func fetchMediaObjects() -> [CDMediaObject] {
        do {
            mediaObjects = try context.fetch(CDMediaObject.fetchRequest())
        } catch {
            print("failed to fetch media objects with error: \(error)")
        }
        return mediaObjects
    }
    
    
}

