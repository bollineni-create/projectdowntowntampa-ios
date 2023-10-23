//
//  AddNoteView.swift
//  PDTampa
//
//  Created by Naren Sai Bollineni on 12/6/23.
//

import Foundation
import SwiftUI
import CoreLocation
import MapKit
import RealmSwift

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
