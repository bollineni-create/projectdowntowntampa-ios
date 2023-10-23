//
//  AddFriendRequestView.swift
//  PDTampa
//
//  Created by Naren Sai Bollineni on 12/6/23.
//

import Foundation
import SwiftUI
import CoreLocation
import MapKit
import RealmSwift

// AddFriendRequestView
struct AddFriendRequestView: View {
    var selectedLocation: String
    var realm: Realm
    
    @State private var friendName: String = ""
    @State private var requestedItem: String = ""
    
    var body: some View {
        VStack {
            TextField("Friend's Name", text: $friendName)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("Requested Item", text: $requestedItem)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button("Save Request") {
                saveFriendRequest()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .padding()
        .navigationBarTitle("Add Friend Request", displayMode: .inline)
    }
    
    func saveFriendRequest() {
        do {
            let newRequest = FriendRequest()
            newRequest.name = friendName
            newRequest.item = requestedItem
            newRequest.location = selectedLocation
            
            try realm.write {
                realm.add(newRequest)
            }
        } catch let error as NSError {
            print("Failed to save request: \(error.localizedDescription)")
        }
    }
}
