//
//  WelcomeView.swift
//  PDTampa
//
//  Created by Naren Sai Bollineni on 12/6/23.
//

import Foundation
import SwiftUI
import CoreLocation
import MapKit
import RealmSwift

// Welcome
struct WelcomeView: View {
    var body: some View {
        VStack {
            Text("Welcome to Project Downtown Tampa!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            Text("Select an option from the sidebar to navigate.")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding()
        .background(LinearGradient(gradient: Gradient(colors: [.white, .gray]), startPoint: .top, endPoint: .bottom))
    }
}
