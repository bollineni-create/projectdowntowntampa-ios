//
//  InputOptionsView.swift
//  PDTampa
//
//  Created by Naren Sai Bollineni on 12/6/23.
//

import Foundation
import SwiftUI
import CoreLocation
import MapKit
import RealmSwift

// InputOptionsView
struct InputOptionsView: View {
    var selectedLocation: String
    var realm: Realm
    
    @State private var navigateToAddNote = false
    @State private var navigateToFriendRequest = false
    @State private var selectedImage: UIImage = UIImage()
    @State private var showImagePicker = false
    @State private var isImagePickerPresented: Bool = false
    @State private var showActionSheet = false
    @State private var selectedSourceType: UIImagePickerController.SourceType = .photoLibrary

    
    var body: some View {
        List {
            Button(action: {
                navigateToAddNote = true
            }) {
                Label("Voice Recording", systemImage: "mic.fill")
            }
            
            Button(action: {
                navigateToAddNote = true
            }) {
                Label("Add Note", systemImage: "note.text")
            }
            .background(NavigationLink("", destination: AddNoteView(selectedLocation: selectedLocation, realm: realm), isActive: $navigateToAddNote))
            
            // New button for adding images
            Button(action: {
                self.showActionSheet = true  // Show the action sheet
            }) {
                Label("Add Picture", systemImage: "photo")
            }
            .actionSheet(isPresented: $showActionSheet) {
                ActionSheet(title: Text("Choose an option"), buttons: [
                    .default(Text("Take Photo")) {
                        self.selectedSourceType = .camera
                        self.isImagePickerPresented = true
                    },
                    .default(Text("Choose from Library")) {
                        self.selectedSourceType = .photoLibrary
                        self.isImagePickerPresented = true
                    },
                    .cancel()
                ])
            }
            .sheet(isPresented: $isImagePickerPresented) {
                ImagePicker(image: self.$selectedImage, sourceType: self.selectedSourceType)  // Use the dynamic source type
            }

            
            // New button for friend request
            Button(action: {
                navigateToFriendRequest = true
            }) {
                Label("Request from Friends", systemImage: "person.fill.questionmark")
            }
            .background(NavigationLink("", destination: AddFriendRequestView(selectedLocation: selectedLocation, realm: realm), isActive: $navigateToFriendRequest))
        }
        .navigationBarTitle("Add Input", displayMode: .inline)
    }
    func saveImage(_ image: UIImage) {
        do {
            let imageData = image.pngData() // Convert UIImage to Data
            let existingData = realm.objects(CounterData.self).filter("location == %@", selectedLocation).first
            try realm.write {
                if let data = existingData {
                    data.imageData = imageData // Save image data
                } else {
                    let counterData = CounterData()
                    counterData.location = selectedLocation
                    counterData.imageData = imageData // Save image data
                    realm.add(counterData)
                }
            }
            print("Image data saved to Realm: \(String(describing: imageData))")  // Debug log
               }    catch let error as NSError {
                   print("Failed to save data: \(error.localizedDescription)")
               }
               }
           }
