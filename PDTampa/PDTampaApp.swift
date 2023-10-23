//
//  PDTampaApp.swift
//  PDTampa
//
//  Created by Naren Sai Bollineni on 9/21/23.
//

import SwiftUI

@main
struct PDTampaApp: App {
    @AppStorage("isDarkMode") var isDarkMode: Bool = false // New line
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(isDarkMode ? .dark : .light) // New line
        }
    }
}

changes
