//
//  ContentView.swift
//  PDTampa
//
//  Created by Naren Sai Bollineni on 9/21/23.
//
import SwiftUI
import CoreLocation
import MapKit
import RealmSwift

// Global Constants
let menuIcons: [String: String] = [
    "Locations": "map.fill",
    "Donation": "gift.fill",
    "Counter": "number.circle.fill",
    "Settings": "gearshape.fill",
    "Contact Info": "person.circle.fill"
]

// Main Content
struct ContentView: View {
    var body: some View {
        NavigationView {
            SidebarView()
            WelcomeView()
        }
    }
}




