//
//  PDTampaApp.swift
//  PDTampa
//
//  Created by Naren Sai Bollineni on 9/21/23.
//

import SwiftUI
import Appwrite
import AuthenticationServices

let client = Client()
    .setEndpoint("https://cloud.appwrite.io/v1")
    .setProject("661bb2a0379cd27a4306")
    .setSelfSigned(true) // For self signed certificates, only use for development

@main
struct PDTampaApp: App {
    @AppStorage("isDarkMode") var isDarkMode: Bool = false // New line
    
    var body: some Scene {
        WindowGroup {
            WelcomeView()
                .preferredColorScheme(isDarkMode ? .dark : .light) // New line
        }
    }
}
