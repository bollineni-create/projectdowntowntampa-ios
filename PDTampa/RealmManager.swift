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

// Realm Classes
class Note: Object {
    @Persisted var text: String = ""
    @Persisted var location: String = ""
    @Persisted var dateAdded: Date = Date()
}

class CounterData: Object {
    @Persisted var location: String = ""
    @Persisted var count: Int = 0
    @Persisted var imageData: Data?  // New property for image data
}


class FriendRequest: Object {
    @Persisted var name: String = ""
    @Persisted var item: String = ""
    @Persisted var location: String = ""
}

