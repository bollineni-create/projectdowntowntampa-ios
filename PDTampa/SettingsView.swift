//
//  SettingsView.swift
//  PDTampa
//
//  Created by Naren Sai Bollineni on 12/6/23.
//

import Foundation
import SwiftUI
import CoreLocation
import MapKit
import RealmSwift

// Settings
struct SettingsView: View {
    @AppStorage("isDarkMode") var isDarkMode: Bool = false
    
    var body: some View {
        List {
            Toggle("Dark Mode", isOn: $isDarkMode)
        }
        .navigationBarTitle("Settings", displayMode: .inline)
    }
}
