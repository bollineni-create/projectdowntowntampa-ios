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

// Define the data model for the network request
struct NetworkCounterData: Codable {
    var Date: String
    var Location: String
    var Number_of_People: Int
    var Comments: String
}

// CounterView definition
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

    // Local and network data handling
    private func saveData() {
        guard let realm = realm else {
            print("Realm is not initialized.")
            return
        }
        do {
            try realm.write {
                let newData: CounterData
                if let existingData = realm.objects(CounterData.self).filter("location == %@", selectedLocation).first {
                    existingData.count += itemsCounted
                    newData = existingData
                } else {
                    newData = CounterData()
                    newData.location = selectedLocation
                    newData.count = itemsCounted
                    realm.add(newData)
                }

                // Prepare and send data to the server
                let networkData = NetworkCounterData(
                    Date: "\(Date())",
                    Location: selectedLocation,
                    Number_of_People: itemsCounted,
                    Comments: "Updated via app"
                )
                postCountData(countData: networkData)  // Send data to the backend
                itemsCounted = 0 // Reset counter after saving
            }
        } catch {
            print("Failed to save data in Realm: \(error.localizedDescription)")
        }
    }

    // Function to post data to the backend
    func postCountData(countData: NetworkCounterData) {
        guard let url = URL(string: "https://nimble-root-421621.ue.r.appspot.com/AddCount") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONEncoder().encode(countData)
            request.httpBody = jsonData
        } catch {
            print("Error encoding data: \(error.localizedDescription)")
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Error with the response, unexpected status code: \((response as? HTTPURLResponse)?.statusCode ?? -1)")
                return
            }
            
            if let error = error {
                print("Error sending data: \(error.localizedDescription)")
                return
            }
            
            print("Data posted successfully!")
        }
        
        task.resume()
    }
}
