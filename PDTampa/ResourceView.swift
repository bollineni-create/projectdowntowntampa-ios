//
//  ResourceView.swift
//  PDTampa
//
//  Created by Naren Sai Bollineni on 4/13/24.
//

import Foundation
import SwiftUI
import CoreLocation
import MapKit
import RealmSwift

struct ResourceView: View {
    var body: some View {
        List(resourceLocations) { location in
            NavigationLink(destination: ResourceDetailView(location: location)) {
                VStack(alignment: .leading) {
                    Text(location.name).font(.headline)
                    Text(location.address).font(.subheadline)
                }
            }
        }
        .navigationTitle("Resources")
    }
}

struct ResourceDetailView: View {
    var location: ResourceLocation

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(location.name).font(.title)
            if let website = location.website {
                Link("Visit Website", destination: website)
            }
            Text(location.address).font(.subheadline)
            Text(location.details).font(.body)
        }
        .padding()
        .navigationBarTitle(Text(location.name), displayMode: .inline)
    }
}

struct ResourceLocation: Identifiable {
    let id = UUID()
    let name: String
    let website: URL?
    let address: String
    let details: String
}

let resourceLocations = [
    ResourceLocation(name: "Leap Tampa Bay", website: URL(string: "https://leaptampabay.org"), address: "123 Leap St", details: "Provides educational resources."),
    ResourceLocation(name: "Caterflies", website: URL(string: "https://caterflies.org"), address: "456 Flutter Ave", details: "Support for children in need."),
    ResourceLocation(name: "CareerSource Tampa Bay", website: URL(string: "https://careersourcetampabay.com"), address: "789 Career Rd", details: "Job training and employment services."),
    ResourceLocation(name: "PowerNet of Tampa", website: URL(string: "https://powernetoftampa.org"), address: "101 Power Ln", details: "Networking events for professionals."),
    ResourceLocation(name: "Metropolitan Ministries Brigade", website: nil, address: "Certification required for DMV services", details: "Identity verification assistance."),
    ResourceLocation(name: "Hyde Park United Methodist", website: nil, address: "Feed on Sundays", details: "Sunday meals for the community."),
    ResourceLocation(name: "Portico Cafe", website: nil, address: "Sunday breakfast", details: "Breakfast service on Sundays."),
    ResourceLocation(name: "St Andrews", website: nil, address: "Daily feed", details: "Daily meal services.")
]

