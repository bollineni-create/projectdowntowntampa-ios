//
//  DonationView.swift
//  PDTampa
//
//  Created by Naren Sai Bollineni on 12/6/23.
//

import Foundation
import SwiftUI
import CoreLocation
import MapKit
import RealmSwift

// Donation
struct DonationView: View {
var body: some View {
    VStack {
        // Your original UI
        Text("Support Our Cause")
            .font(.largeTitle)
        Text("Your donation helps us continue our mission")
            .multilineTextAlignment(.center)
        Link("Donate via PayPal", destination: URL(string: "https://www.paypal.com/donate/?hosted_button_id=NDGVYCC8AJKGL")!)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
    }
    .navigationBarTitle("Donation", displayMode: .inline)
    .padding()
}
}
