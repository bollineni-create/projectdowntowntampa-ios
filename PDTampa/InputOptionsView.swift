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
            
            // New button for adding Notes
            
            Button(action: {
                navigateToAddNote = true
            }) {
                Label("Add Note", systemImage: "note.text")
            }
            .background(NavigationLink("", destination: AddNoteView(selectedLocation: selectedLocation, realm: realm), isActive: $navigateToAddNote))
            
            // New button for adding Images
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


// ADD NOTES

// AddNoteView
struct AddNoteView: View {
    var selectedLocation: String
    @State private var noteText: String = ""
    @State private var showAlert = false
    var realm: Realm
    
    init(selectedLocation: String, realm: Realm) {
        self.selectedLocation = selectedLocation
        self.realm = realm
    }
    
    var body: some View {
        VStack {
            TextEditor(text: $noteText)
                .padding()
                .navigationBarTitle("Add Note", displayMode: .inline)
            
            Button("Save Note") {
                saveNote()
            }
            .padding()
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Note Saved"), message: Text("Your note has been saved."), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    func saveNote() {
        do {
            let newNote = Note()
            newNote.text = noteText
            newNote.location = selectedLocation
            
            try realm.write {
                realm.add(newNote)
            }
            
            self.showAlert = true
        } catch let error as NSError {
            print("Failed to save note: \(error.localizedDescription)")
        }
    }
}

struct EditableText: View {
    var label: String
    var data: String
    var onUpdate: (String) -> Void
    
    @State private var isEditing = false
    @State private var editText: String
    
    init(label: String, data: String, onUpdate: @escaping (String) -> Void) {
        self.label = label
        self.data = data
        self.onUpdate = onUpdate
        _editText = State(initialValue: data)
    }
    
    var body: some View {
        if isEditing {
            TextField("Edit \(label)", text: $editText, onCommit: {
                isEditing = false
                onUpdate(editText)
            })
            .textFieldStyle(RoundedBorderTextFieldStyle())
        } else {
            Text("\(label): \(data)")
                .onTapGesture {
                    isEditing = true
                }
        }
    }
}

// ADD PICTURES

//AddPictureView
struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) private var presentationMode
    @Binding var image: UIImage
    
    var sourceType: UIImagePickerController.SourceType  // New property
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = sourceType  // Set the source type
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let uiImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                parent.image = uiImage
                saveImageToRealm(image: uiImage)
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func saveImageToRealm(image: UIImage) {
            if let imageData = image.jpegData(compressionQuality: 0.8) {
                let realm = try! Realm()
                let counterData = CounterData() // Assuming CounterData is your Realm model
                counterData.imageData = imageData
                try! realm.write {
                    realm.add(counterData)
                }
            }
        }
    }
}


// FRIEND REQUESTS

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
