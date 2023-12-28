//
//  ContactInfoView.swift
//  PDTampa
//
//  Created by Naren Sai Bollineni on 12/6/23.
//

import Foundation
import SwiftUI
import CoreLocation
import MapKit
import RealmSwift

// ContactInfo
struct ContactInfoView: View {
    let contacts: [(name: String, phoneNumber: String)] = [
        ("President: Naren ", "tel://+13212468950"),
        ("Vice President: Nida", "tel://+18506258919")
    ]
    
    var body: some View {
        List(contacts, id: \.name) { contact in
            HStack {
                Text(contact.name)
                Spacer()
                Image(systemName: "phone.fill")
            }
            .contentShape(Rectangle())
            .onTapGesture {
                if let url = URL(string: contact.phoneNumber) {
                    UIApplication.shared.open(url)
                }
            }
        }
        .navigationBarTitle("Contact Info", displayMode: .inline)
    }
}
