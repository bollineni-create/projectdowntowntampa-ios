//
//  CounterView.swift
//  PDTampa
//
//  Created by Naren Sai Bollineni on 12/6/23.
//

import Foundation
import SwiftUI
import CoreLocation
import MapKit
import RealmSwift


// Counter

// CounterView
struct CounterView: View {
    @State private var itemsCounted: Int = 0
    @State private var selectedLocation: String = "Borell Park"
    @State private var navigateToInputOptions = false
    let locations = ["Borell Park", "Bus Stop 1", "Bus Stop 2", "Bus Stop 3", "Gaslight Park", "Good Sam", "Graveyard"]
    
    var realm: Realm
    init() {
        do {
            let config = Realm.Configuration(
                schemaVersion: 1,
                migrationBlock: { migration, oldSchemaVersion in
                    if oldSchemaVersion < 1 {
                        migration.enumerateObjects(ofType: Note.className()) { oldObject, newObject in
                            newObject!["location"] = ""
                        }
                    }
                }
            )
            Realm.Configuration.defaultConfiguration = config
            realm = try Realm()
        } catch let error as NSError {

            fatalError("Failed to initialize Realm: \(error.localizedDescription)")
        }
    }
    
    func saveData() {
        do {
            let existingData = realm.objects(CounterData.self).filter("location == %@", selectedLocation).first
            try realm.write {
                if let data = existingData {
                    data.count += itemsCounted
                } else if itemsCounted >= 0 {
                    let counterData = CounterData()
                    counterData.location = selectedLocation
                    counterData.count = itemsCounted
                    realm.add(counterData)
                }
            }
            itemsCounted = 0  // Clear the field
        } catch let error as NSError {
            print("Failed to save data: \(error.localizedDescription)")
        }
    }
    
    var body: some View {
        VStack {
            Text("Friday Data")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 50)
                .frame(maxWidth: .infinity, alignment: .center)
            
            Picker("Locations", selection: $selectedLocation) {
                ForEach(locations, id: \.self) { location in
                    Text(location)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .padding(.horizontal)
            .padding(.top, 20)
            .onChange(of: selectedLocation) { newValue in
                itemsCounted = 0
            }
            
            Spacer()
            
            let numberRange: [Int] = Array(0...100)
            Picker(selection: $itemsCounted, label: Text("Counter")) {
                ForEach(numberRange, id: \.self) { num in
                    Text("\(num)").tag(num)
                }
            }
            .pickerStyle(WheelPickerStyle())
            .frame(width: 100, height: 150, alignment: .center)
            .clipped()
            
            Button("Submit Data") {
                saveData()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
            
            NavigationLink(destination: CounterDataListView()) {
                Text("View Saved Data")
                    .padding()
                    .background(Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding(.top, 20)
        }
        .navigationBarTitle("Counter", displayMode: .inline)
        .navigationBarItems(trailing: Button(action: {
            navigateToInputOptions = true
        }) {
            Image(systemName: "square.and.pencil")
        })
        .background(NavigationLink("", destination: InputOptionsView(selectedLocation: selectedLocation, realm: realm), isActive: $navigateToInputOptions))
    }
}
