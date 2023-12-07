//
//  CounterDataListView.swift
//  PDTampa
//
//  Created by Naren Sai Bollineni on 12/6/23.
//

import Foundation
import SwiftUI
import CoreLocation
import MapKit
import RealmSwift

// CounterDataListView
struct CounterDataListView: View {
    @State private var counterData: [CounterData] = []
    @State private var savedNotes: [Note] = []
    @State private var friendRequests: [FriendRequest] = []
    
    var body: some View {
        VStack {
            NavigationView {
                List {
                    ForEach(Set(counterData.map { $0.location } + savedNotes.map { $0.location }).sorted(), id: \.self) { location in
                        Section(header: Text(location)) {
                            
                            // Fetching counts recorded in the Counter
                            ForEach(counterData.filter { $0.location == location }, id: \.self) { countData in
                                HStack {
                                    EditableText(label: "Count", data: "\(countData.count)") { newText in
                                        if let newCount = Int(newText) {
                                            let realm = try! Realm()
                                            try! realm.write {
                                                countData.count = newCount
                                            }
                                        }
                                    }
                                }
                            }
                            
                            // Fetching images recorded in the Counter
                            ForEach(counterData.filter { $0.location == location && $0.imageData != nil }, id: \.self) { countData in
                                if let imageData = countData.imageData, let uiImage = UIImage(data: imageData) {
                                    HStack {
                                        EditableText(label: "Image", data: "") { _ in
                                        }
                                        Image(uiImage: uiImage)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 50, height: 50)
                                    }
                                }
                            }


                            // Fetching notes recorded in the Counter
                            ForEach(savedNotes.filter { $0.location == location }, id: \.self) { note in
                                EditableText(label: "Note", data: note.text) { newText in
                                    let realm = try! Realm()
                                    try! realm.write {
                                        note.text = newText
                                    }
                                }
                            }
                            // Fetching requests recorded in the Counter
                            ForEach(friendRequests.filter { $0.location == location }, id: \.self) { request in
                                EditableText(label: "Request from \(request.name) for", data: request.item) { newText in
                                    let realm = try! Realm()
                                    try! realm.write {
                                        request.item = newText
                                    }
                                }
                            }
                        }
                    }
                }
                .listStyle(GroupedListStyle())
                .navigationBarTitle("Saved Data", displayMode: .inline)
            }
            
            Button("Clear Data") {
                let realm = try! Realm()
                try! realm.write {
                    realm.deleteAll()
                }
                loadData()
            }
            .padding()
            .background(Color.red)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .onAppear {
            loadData()
        }
    }
    
    private func loadData() {
        let realm = try! Realm()
        counterData = Array(realm.objects(CounterData.self))
        savedNotes = Array(realm.objects(Note.self))
        friendRequests = Array(realm.objects(FriendRequest.self))
    }
}
