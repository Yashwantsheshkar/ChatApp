//
//  AuthViewModel.swift
//  ChatApp
//
//  Created by Yashwant Sheshkar on 12/06/25.
//

import Foundation
import Combine

@MainActor
class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var isLoading = true
    @Published var user: User?
    @Published var errorMessage: String?
    @Published var showingProfileSetup = false
    
    private let apiService = APIService.shared
    
    func checkAuthenticationStatus() {
        // Show splash for 2 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            // Check if user is already logged in
            if let token = UserDefaults.standard.authToken,
               let userData = UserDefaults.standard.userData {
                self.user = userData
                self.isAuthenticated = true
            }
            self.isLoading = false
        }
    }
    
    func login(phoneNumber: String) async {
        do {
            let user = try await apiService.login(
                dialCode: "+91",
                mobileNumber: Int64(phoneNumber) ?? 0
            )
            
            self.user = user
            UserDefaults.standard.authToken = user.authToken
            UserDefaults.standard.userData = user
            
            if user.onboardingPending {
                showingProfileSetup = true
            } else {
                isAuthenticated = true
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func updateProfile(firstName: String, lastName: String) async {
        guard let token = user?.authToken else { return }
        
        do {
            let updatedUser = try await apiService.updateProfile(
                firstName: firstName,
                lastName: lastName,
                token: token
            )
            
            self.user = updatedUser
            UserDefaults.standard.userData = updatedUser
            showingProfileSetup = false
            isAuthenticated = true
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func logout() {
        isAuthenticated = false
        user = nil
        UserDefaults.standard.removeObject(forKey: "authToken")
        UserDefaults.standard.removeObject(forKey: "userData")
        SocketService.shared.disconnect()
    }
}
