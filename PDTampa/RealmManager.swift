//
//  RealmManager.swift
//  PDTampa
//
//  Created by Naren Sai Bollineni on 12/6/23.
//

import Foundation
import SwiftUI
import CoreLocation
import MapKit
import RealmSwift

struct RealmManager {
    static func setupRealm() -> Realm? {
        let config = Realm.Configuration(
            schemaVersion: 1, // Adjust based on your schema versioning.
            migrationBlock: { migration, oldSchemaVersion in
                if oldSchemaVersion < 1 {
                    // Execute migration logic if necessary
                }
            },
            deleteRealmIfMigrationNeeded: true // Useful during development, not recommended for production.
        )
        Realm.Configuration.defaultConfiguration = config
        
        do {
            let realm = try Realm()
            return realm
        } catch {
            print("Failed to initialize Realm: \(error)")
            return nil
        }
    }
}

class CounterData: Object {
    @Persisted var location: String = ""
    @Persisted var count: Int = 0
    @Persisted var imageData: Data?
    @Persisted var dateEntered: Date = Date()
}

class Note: Object {
    @Persisted var text: String = ""
    @Persisted var location: String = ""
    @Persisted var dateAdded: Date = Date()
}

class FriendRequest: Object {
    @Persisted var name: String = ""
    @Persisted var item: String = ""
    @Persisted var location: String = ""
}

