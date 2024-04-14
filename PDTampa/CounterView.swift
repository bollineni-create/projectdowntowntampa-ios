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

// CounterView

struct CounterView: View {
    @State private var itemsCounted: Int = 0
    @State private var selectedLocation: String = "Borell Park"
    @State private var navigateToInputOptions = false
    @State private var navigateToDataList = false
    let locations = ["Borell Park", "Bus Stop 1", "Bus Stop 2", "Bus Stop 3", "Gaslight Park", "Good Sam", "Graveyard"]
    var realm: Realm?
    
    init() {
        realm = RealmManager.setupRealm()
    }

    var body: some View {
        VStack {
            Text("Select Location")
                .font(.headline)
                .padding()
            
            Picker("Locations", selection: $selectedLocation) {
                ForEach(locations, id: \.self) { location in
                    Text(location)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .padding()

            Spacer()

            Text("\(itemsCounted)")
                .font(.system(size: 72))
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .contentShape(Rectangle())
                .onTapGesture {
                    itemsCounted += 1
                }

            Button("Submit Data") {
                saveData()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)

            NavigationLink(destination: InputOptionsView(selectedLocation: selectedLocation, realm: realm!), isActive: $navigateToInputOptions) {
                EmptyView()
            }

            NavigationLink(destination: CounterDataListView(), isActive: $navigateToDataList) {
                EmptyView()
            }

            Button("View Saved Data") {
                navigateToDataList = true
            }
            .padding()
            .background(Color.gray)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .navigationBarTitle("Counter", displayMode: .inline)
        .navigationBarItems(trailing: Button(action: {
            navigateToInputOptions = true
        }) {
            Image(systemName: "square.and.pencil")
        })
    }

    private func saveData() {
        guard let realm = realm else {
            print("Realm is not initialized.")
            return
        }
        do {
            try realm.write {
                if let existingData = realm.objects(CounterData.self).filter("location == %@", selectedLocation).first {
                    existingData.count += itemsCounted
                } else {
                    let newCounterData = CounterData()
                    newCounterData.location = selectedLocation
                    newCounterData.count = itemsCounted
                    realm.add(newCounterData)
                }
            }
            itemsCounted = 0 // Reset counter after saving
        } catch {
            print("Failed to save data in Realm: \(error.localizedDescription)")
        }
    }
}
