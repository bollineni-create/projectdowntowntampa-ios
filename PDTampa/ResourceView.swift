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
    ResourceLocation(name: "St Andrews", website: nil, address: "Daily feed", details: "Daily meal services."),
    ResourceLocation(name: "Trinity Cafe 1", website: URL(string: "https://feedingtampabay.org"), address: "2801 N. Nebraska Ave. Tampa, FL 33602", details: "Hot meals served Mon-Fri 11:30 am - 12:30 pm, Sat-Sun 9:00 am - 10:00 am; Frozen To-Go Meals available Mon-Fri 11:30 am - 12:30 pm & Sat-Sun 9:00 am - 10:00 am. Contact: (813) 865-4822"),
    ResourceLocation(name: "Trinity Cafe 2", website: URL(string: "https://feedingtampabay.org"), address: "2202 E. Busch Blvd. Tampa, FL 33612", details: "Hot meals served Mon-Fri 11:30 am - 12:30 pm, Sat 9:00 am - 10:00 am; Frozen To-Go Meals available Mon-Fri 11:30 am - 12:30 pm & Sat 9:00 am - 10:00 am; Mobile Pantry 1st Saturday of the month 9:30 am - 11:00 am. Temporarily located at 8715 N 22nd St, Tampa, FL 33604 (school bus ramp off Yukon). Contact: (813) 865-4822"),
    ResourceLocation(name: "Trinity Cafe 3", website: URL(string: "https://feedingtampabay.org"), address: "6330 54th Ave N, St. Petersburg, FL 33709", details: "Hot Meals served Mon-Fri 5:30 pm - 6:30 pm; Feeding Minds Food Pantry; Benefits Assistance Program; Nutrition Education; FRESHforce - Workforce development program; Healthy Vending Machines; Showers; Laundry; Clothing Closet; Rotating services include Diapers & Baby Supplies, Rental & Utility Emergency Assistance, Adult Education Courses, Financial Literacy Courses, Citizenship Resources, Housing Resources, Legal Services, VITA Assistance, Medical Services, HIV Testing. Contact: (813) 710-6269"),

    
]

