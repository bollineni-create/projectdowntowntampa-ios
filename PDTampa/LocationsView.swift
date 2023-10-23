//
//  LocationsView.swift
//  PDTampa
//
//  Created by Naren Sai Bollineni on 12/6/23.
//

import Foundation
import SwiftUI
import CoreLocation
import MapKit
import RealmSwift

// Locations
struct LocationsView: View {
    struct Location: Identifiable, Equatable {
        let id = UUID()
        let name: String
        let address: String
        let coordinate: CLLocationCoordinate2D
        
        static func == (lhs: Location, rhs: Location) -> Bool {
            return lhs.id == rhs.id
        }
    }
    
    @State private var selectedLocation: Location?
    
    let locations: [Location] = [
            Location(name: "Borell Park", address: "808 E 26th Ave, Tampa, FL 33603", coordinate: CLLocationCoordinate2D(latitude: 27.975355, longitude: -82.451640)),
            Location(name: "Bus Stop 1", address: "Marion St + Cass St, Tampa, FL 33602", coordinate: CLLocationCoordinate2D(latitude: 27.952358, longitude: -82.458045)),
            Location(name: "Bus Stop 2", address: "Marion St + Zack St, Tampa, FL 33602", coordinate: CLLocationCoordinate2D(latitude: 27.950813, longitude: -82.457344)),
            Location(name: "Bus Stop 3", address: "Marion St N + Kennedy Blvd E, Tampa, FL 33602", coordinate: CLLocationCoordinate2D(latitude: 27.948645, longitude: -82.456405)),
            Location(name: "Gaslight Park", address: "241 E Madison St, Tampa, FL 33602", coordinate: CLLocationCoordinate2D(latitude: 27.947951, longitude: -82.458507)),
            Location(name: "Good Sam", address: "3302 N Florida Ave, Tampa, FL 33603", coordinate: CLLocationCoordinate2D(latitude: 27.974912, longitude: -82.459724)),
            Location(name: "Graveyard", address: "1301 N Morgan St, Tampa, FL 33602", coordinate: CLLocationCoordinate2D(latitude: 27.955935, longitude: -82.457871)),
            Location(name: "Bridge", address: "320 Bayshore Blvd, Tampa, FL 33606", coordinate: CLLocationCoordinate2D(latitude: 27.940439, longitude: -82.459692))
        ]
        
        @State private var region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 27.975355, longitude: -82.451640),
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
        
        var body: some View {
            VStack {
                Map(coordinateRegion: $region, annotationItems: locations) { location in
                    MapPin(coordinate: location.coordinate, tint: location.id == selectedLocation?.id ? .red : .blue)
                }
                .frame(height: 300)
                .onChange(of: selectedLocation) { newLocation in
                    if let coordinate = newLocation?.coordinate {
                        region.center = coordinate
                    }
                }
                
                List(locations, id: \.id) { location in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(location.name)
                                .font(.headline)
                            Text(location.address)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    .contentShape(Rectangle())  // Makes the entire row tappable
                    .onTapGesture {
                        selectedLocation = location
                    }
                }
                
                if let selectedLocation = selectedLocation {
                    Button(action: {
                        openMapsApp(location: selectedLocation)
                    }) {
                        HStack {
                            Text("Go to \(selectedLocation.name)")
                            Image(systemName: "arrow.right.circle.fill")
                        }
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color.green)
                    .cornerRadius(8)
                    .padding(.bottom, 16)
                }
            }
        }
        
        private func openMapsApp(location: Location) {
            let coordinate = location.coordinate
            let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
            mapItem.name = location.name
            mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
        }
    }
