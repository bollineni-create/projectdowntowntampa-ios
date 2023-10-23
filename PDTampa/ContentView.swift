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

// HEX color support
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

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

// ContactInfo
struct ContactInfoView: View {
    let contacts: [(name: String, phoneNumber: String)] = [
        ("President: Naren ", "tel://+13212468950"),
        ("Vice President: Nida", "tel://+18506258919"),
        ("Volunteer Coordinator: Ammar", "tel://+13525845550"),
        ("Historian: Anmol", "tel://+18502576005"),
        ("Treasurer: Lila", "tel://+18137132250"),
        ("Food Prep Coordinator: Amanda Zaineb", "tel://+18138628266"),
        ("Food Prep Coordinator #2: Sunny", "tel://+18135992519"),
        ("Food Prep Coordinator #3: Christopher", "tel://+18135985600"),
        ("Event Coordinator: Zeina", "tel://+13054577669")
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


// Locations
struct LocationsView: View {
    struct Location: Identifiable, Equatable {
        let id = UUID()
        let name: String
        let address: String
        let coordinate: CLLocationCoordinate2D
        
        static func == (lhs: Location, rhs: Location) -> Bool {
            return lhs.id == rhs.id
        }
    }
    
    @State private var selectedLocation: Location?
    
    let locations: [Location] = [
            Location(name: "Borell Park", address: "808 E 26th Ave, Tampa, FL 33603", coordinate: CLLocationCoordinate2D(latitude: 27.975355, longitude: -82.451640)),
            Location(name: "Bus Stop 1", address: "Marion St + Cass St, Tampa, FL 33602", coordinate: CLLocationCoordinate2D(latitude: 27.952358, longitude: -82.458045)),
            Location(name: "Bus Stop 2", address: "Marion St + Zack St, Tampa, FL 33602", coordinate: CLLocationCoordinate2D(latitude: 27.950813, longitude: -82.457344)),
            Location(name: "Bus Stop 3", address: "Marion St N + Kennedy Blvd E, Tampa, FL 33602", coordinate: CLLocationCoordinate2D(latitude: 27.948645, longitude: -82.456405)),
            Location(name: "Gaslight Park", address: "241 E Madison St, Tampa, FL 33602", coordinate: CLLocationCoordinate2D(latitude: 27.947951, longitude: -82.458507)),
            Location(name: "Good Sam", address: "3302 N Florida Ave, Tampa, FL 33603", coordinate: CLLocationCoordinate2D(latitude: 27.974912, longitude: -82.459724)),
            Location(name: "Graveyard", address: "1301 N Morgan St, Tampa, FL 33602", coordinate: CLLocationCoordinate2D(latitude: 27.955935, longitude: -82.457871)),
            Location(name: "Bridge", address: "320 Bayshore Blvd, Tampa, FL 33606", coordinate: CLLocationCoordinate2D(latitude: 27.940439, longitude: -82.459692))
        ]
        
        @State private var region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 27.975355, longitude: -82.451640),
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
        
        var body: some View {
            VStack {
                Map(coordinateRegion: $region, annotationItems: locations) { location in
                    MapPin(coordinate: location.coordinate, tint: location.id == selectedLocation?.id ? .red : .blue)
                }
                .frame(height: 300)
                .onChange(of: selectedLocation) { newLocation in
                    if let coordinate = newLocation?.coordinate {
                        region.center = coordinate
                    }
                }
                
                List(locations, id: \.id) { location in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(location.name)
                                .font(.headline)
                            Text(location.address)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    .contentShape(Rectangle())  // Makes the entire row tappable
                    .onTapGesture {
                        selectedLocation = location
                    }
                }
                
                if let selectedLocation = selectedLocation {
                    Button(action: {
                        openMapsApp(location: selectedLocation)
                    }) {
                        HStack {
                            Text("Go to \(selectedLocation.name)")
                            Image(systemName: "arrow.right.circle.fill")
                        }
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color.green)
                    .cornerRadius(8)
                    .padding(.bottom, 16)
                }
            }
        }
        
        private func openMapsApp(location: Location) {
            let coordinate = location.coordinate
            let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
            mapItem.name = location.name
            mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
        }
    }
    
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

// Counter

// CounterView
struct CounterView: View {
    @State private var itemsCounted: Int = 0
    @State private var selectedLocation: String = "Borell Park"
    @State private var navigateToInputOptions = false
    let locations = ["Borell Park", "Bus Stop 1", "Bus Stop 2", "Bus Stop 3", "Gaslight Park", "Good Sam", "Graveyard"]
    
    var realm: Realm
    init() {
        do {
            let config = Realm.Configuration(
                schemaVersion: 1,
                migrationBlock: { migration, oldSchemaVersion in
                    if oldSchemaVersion < 1 {
                        migration.enumerateObjects(ofType: Note.className()) { oldObject, newObject in
                            newObject!["location"] = ""
                        }
                    }
                }
            )
            Realm.Configuration.defaultConfiguration = config
            realm = try Realm()
        } catch let error as NSError {
            fatalError("Failed to initialize Realm: \(error.localizedDescription)")
        }
    }
    
    func saveData() {
        do {
            let existingData = realm.objects(CounterData.self).filter("location == %@", selectedLocation).first
            try realm.write {
                if let data = existingData {
                    data.count += itemsCounted
                } else if itemsCounted >= 0 {
                    let counterData = CounterData()
                    counterData.location = selectedLocation
                    counterData.count = itemsCounted
                    realm.add(counterData)
                }
            }
            itemsCounted = 0  // Clear the field
        } catch let error as NSError {
            print("Failed to save data: \(error.localizedDescription)")
        }
    }
    
    var body: some View {
        VStack {
            Text("Friday Data")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 50)
                .frame(maxWidth: .infinity, alignment: .center)
            
            Picker("Locations", selection: $selectedLocation) {
                ForEach(locations, id: \.self) { location in
                    Text(location)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .padding(.horizontal)
            .padding(.top, 20)
            .onChange(of: selectedLocation) { newValue in
                itemsCounted = 0
            }
            
            Spacer()
            
            let numberRange: [Int] = Array(0...100)
            Picker(selection: $itemsCounted, label: Text("Counter")) {
                ForEach(numberRange, id: \.self) { num in
                    Text("\(num)").tag(num)
                }
            }
            .pickerStyle(WheelPickerStyle())
            .frame(width: 100, height: 150, alignment: .center)
            .clipped()
            
            Button("Submit Data") {
                saveData()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
            
            NavigationLink(destination: CounterDataListView()) {
                Text("View Saved Data")
                    .padding()
                    .background(Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding(.top, 20)
        }
        .navigationBarTitle("Counter", displayMode: .inline)
        .navigationBarItems(trailing: Button(action: {
            navigateToInputOptions = true
        }) {
            Image(systemName: "square.and.pencil")
        })
        .background(NavigationLink("", destination: InputOptionsView(selectedLocation: selectedLocation, realm: realm), isActive: $navigateToInputOptions))
    }
}

// InputOptionsView
struct InputOptionsView: View {
    var selectedLocation: String
    var realm: Realm
    
    @State private var navigateToAddNote = false
    @State private var navigateToFriendRequest = false
    
    var body: some View {
        List {
            Button(action: {
                navigateToAddNote = true
            }) {
                Label("Voice Recording", systemImage: "mic.fill")
            }
            
            Button(action: {
                navigateToAddNote = true
            }) {
                Label("Add Note", systemImage: "note.text")
            }
            .background(NavigationLink("", destination: AddNoteView(selectedLocation: selectedLocation, realm: realm), isActive: $navigateToAddNote))
            
            Button(action: {}) {
                Label("Add Picture", systemImage: "photo")
            }
            
            // New button for friend request
            Button(action: {
                navigateToFriendRequest = true
            }) {
                Label("Request from Friends", systemImage: "person.fill.questionmark")
            }
            .background(NavigationLink("", destination: AddFriendRequestView(selectedLocation: selectedLocation, realm: realm), isActive: $navigateToFriendRequest))
        }
        .navigationBarTitle("Add Input", displayMode: .inline)
    }
}

// AddNoteView
struct AddNoteView: View {
    var selectedLocation: String
    @State private var noteText: String = ""
    @State private var showAlert = false
    var realm: Realm
    
    init(selectedLocation: String, realm: Realm) {
        self.selectedLocation = selectedLocation
        self.realm = realm
    }
    
    var body: some View {
        VStack {
            TextEditor(text: $noteText)
                .padding()
                .navigationBarTitle("Add Note", displayMode: .inline)
            
            Button("Save Note") {
                saveNote()
            }
            .padding()
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Note Saved"), message: Text("Your note has been saved."), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    func saveNote() {
        do {
            let newNote = Note()
            newNote.text = noteText
            newNote.location = selectedLocation
            
            try realm.write {
                realm.add(newNote)
            }
            
            self.showAlert = true
        } catch let error as NSError {
            print("Failed to save note: \(error.localizedDescription)")
        }
    }
}

// AddFriendRequestView
struct AddFriendRequestView: View {
    var selectedLocation: String
    var realm: Realm
    
    @State private var friendName: String = ""
    @State private var requestedItem: String = ""
    
    var body: some View {
        VStack {
            TextField("Friend's Name", text: $friendName)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("Requested Item", text: $requestedItem)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button("Save Request") {
                saveFriendRequest()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .padding()
        .navigationBarTitle("Add Friend Request", displayMode: .inline)
    }
    
    func saveFriendRequest() {
        do {
            let newRequest = FriendRequest()
            newRequest.name = friendName
            newRequest.item = requestedItem
            newRequest.location = selectedLocation
            
            try realm.write {
                realm.add(newRequest)
            }
        } catch let error as NSError {
            print("Failed to save request: \(error.localizedDescription)")
        }
    }
}

// CounterDataListView
struct CounterDataListView: View {
    @State private var counterData: [CounterData] = []
    @State private var savedNotes: [Note] = []
    @State private var friendRequests: [FriendRequest] = []
    
    var body: some View {
        VStack {
            NavigationView {
                List {
                    ForEach(Set(counterData.map { $0.location } + savedNotes.map { $0.location }).sorted(), id: \.self) { location in
                        Section(header: Text(location)) {
                            ForEach(counterData.filter { $0.location == location }, id: \.self) { countData in
                                EditableText(label: "Count", data: "\(countData.count)") { newText in
                                    if let newCount = Int(newText) {
                                        let realm = try! Realm()
                                        try! realm.write {
                                            countData.count = newCount
                                        }
                                    }
                                }
                            }
                            
                            ForEach(savedNotes.filter { $0.location == location }, id: \.self) { note in
                                EditableText(label: "Note:", data: note.text) { newText in
                                    let realm = try! Realm()
                                    try! realm.write {
                                        note.text = newText
                                    }
                                }
                            }
                            
                            ForEach(friendRequests.filter { $0.location == location }, id: \.self) { request in
                                EditableText(label: "Request from \(request.name) for", data: request.item) { newText in
                                    let realm = try! Realm()
                                    try! realm.write {
                                        request.item = newText
                                    }
                                }
                            }
                        }
                    }
                }
                .listStyle(GroupedListStyle())
                .navigationBarTitle("Saved Data", displayMode: .inline)
            }
            
            Button("Clear Data") {
                let realm = try! Realm()
                try! realm.write {
                    realm.deleteAll()
                }
                loadData()
            }
            .padding()
            .background(Color.red)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .onAppear {
            loadData()
        }
    }
    
    private func loadData() {
        let realm = try! Realm()
        counterData = Array(realm.objects(CounterData.self))
        savedNotes = Array(realm.objects(Note.self))
        friendRequests = Array(realm.objects(FriendRequest.self))
    }
}

struct EditableText: View {
    var label: String
    var data: String
    var onUpdate: (String) -> Void
    
    @State private var isEditing = false
    @State private var editText: String
    
    init(label: String, data: String, onUpdate: @escaping (String) -> Void) {
        self.label = label
        self.data = data
        self.onUpdate = onUpdate
        _editText = State(initialValue: data)
    }
    
    var body: some View {
        if isEditing {
            TextField("Edit \(label)", text: $editText, onCommit: {
                isEditing = false
                onUpdate(editText)
            })
            .textFieldStyle(RoundedBorderTextFieldStyle())
        } else {
            Text("\(label): \(data)")
                .onTapGesture {
                    isEditing = true
                }
        }
    }
}

// Realm Classes
class Note: Object {
    @Persisted var text: String = ""
    @Persisted var location: String = ""
    @Persisted var dateAdded: Date = Date()
}

class CounterData: Object {
    @Persisted var location: String = ""
    @Persisted var count: Int = 0
}

class FriendRequest: Object {
    @Persisted var name: String = ""
    @Persisted var item: String = ""
    @Persisted var location: String = ""
}

