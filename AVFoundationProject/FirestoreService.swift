//
//  FirestoreSession.swift
//  AVFoundationProject
//
//  Created by Ahad Islam on 4/16/20.
//  Copyright © 2020 Ahad Islam. All rights reserved.
//

import Foundation
import FirebaseFirestore

class FirestoreService {
    private init() {}
    static let session = FirestoreService()
    
    static let activitiesCollection = "activities"
    
    private let db = Firestore.firestore()
    
    public func getDocuments(completion: @escaping (Result<[(String, String)], Error>) -> Void) {
        db.collection(FirestoreService.activitiesCollection).getDocuments { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else if let snapshot = snapshot {
                let y = snapshot.documents.compactMap {
                    return ($0.data()["title"] as! String, $0.data()["description"] as! String)
                }
                completion(.success(y))
            }
        }
    }
}
