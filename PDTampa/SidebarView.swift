//
//  SidebarView.swift
//  PDTampa
//
//  Created by Naren Sai Bollineni on 12/6/23.
//

import Foundation
import SwiftUI
import CoreLocation
import MapKit
import RealmSwift

// Sidebar
struct SidebarView: View {
    let palette: [Color] = [
        Color(hex: "0199f5"),
        Color(hex: "d8d8d8"),
        Color(hex: "ffffff"),
        Color(hex: "070809"),
        Color(hex: "01324f"),
        Color(hex: "0492e3"),
        Color(hex: "010206")
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 15) {
                NavigationLink(destination: LocationsView()) {
                    menuItem(title: "Locations", icon: "map.fill", color: palette[0])
                }
                NavigationLink(destination: DonationView()) {
                    menuItem(title: "Donation", icon: "gift.fill", color: palette[4])
                }
                NavigationLink(destination: CounterView()) {
                    menuItem(title: "Counter", icon: "number.circle.fill", color: palette[5])
                }
                NavigationLink(destination: SettingsView()) {
                    menuItem(title: "Settings", icon: "gearshape.fill", color: palette[1])
                }
                NavigationLink(destination: ContactInfoView()) {
                              menuItem(title: "Contact Info", icon: "person.circle.fill", color: palette[5])
                          }
                      }
                      .padding(.top)
                  }
                  .padding(.horizontal)
                  .navigationTitle("Menu")
              }
    
    func menuItem(title: String, icon: String, color: Color) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.white)
                .imageScale(.large)
                .padding(.leading, 20)
            Text(title)
                .foregroundColor(.white)
                .fontWeight(.medium)
            Spacer()
        }
        .padding(.vertical, 10)
        .frame(maxWidth: .infinity)
        .background(color)
        .cornerRadius(15)
    }
}
