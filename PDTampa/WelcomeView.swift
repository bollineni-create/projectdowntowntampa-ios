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
import AuthenticationServices


// MARK: - SignInWithAppleButton SwiftUI Wrapper
struct SignInWithAppleButton: UIViewRepresentable {
    func makeUIView(context: Context) -> ASAuthorizationAppleIDButton {
        return ASAuthorizationAppleIDButton(type: .signIn, style: .black)
    }
    
    func updateUIView(_ uiView: ASAuthorizationAppleIDButton, context: Context) {}
    
    typealias UIViewType = ASAuthorizationAppleIDButton
}

// MARK: - SignInWithApple Coordinator
final class SignInWithAppleCoordinator: NSObject, ASAuthorizationControllerDelegate {
    var onSignInSuccess: () -> Void

    init(onSignInSuccess: @escaping () -> Void) {
        self.onSignInSuccess = onSignInSuccess
    }

    func handleAuthorizationAppleIDButtonPress() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.performRequests()
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let _ = authorization.credential as? ASAuthorizationAppleIDCredential {
            onSignInSuccess()  // Trigger the closure to update the authentication state
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Error in Apple ID Authorization: \(error)")
    }
}

// MARK: - WelcomeView SwiftUI View
struct WelcomeView: View {
    @State private var isAuthenticated = false

    var body: some View {
        ZStack {
            if isAuthenticated {
                ContentView()
                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
            }

            if !isAuthenticated {
                nonAuthenticatedView
                    .transition(.asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .trailing)))
            }
        }
        .animation(.easeInOut, value: isAuthenticated)
    }

    var nonAuthenticatedView: some View {
        let coordinator = SignInWithAppleCoordinator {
            isAuthenticated = true
        }

        return VStack {
            Text("Welcome to Project Downtown Tampa")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 50)
                .foregroundColor(.white)
            
            Spacer()
            
            SignInWithAppleButton()
                .frame(width: 280, height: 45)
                .onTapGesture {
                    coordinator.handleAuthorizationAppleIDButtonPress()
                }
                .padding(.bottom, 50)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Image("WelcomeBackground")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
        )
    }
}


// MARK: - Preview Provider for SwiftUI Canvas
struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
