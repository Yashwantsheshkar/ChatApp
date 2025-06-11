//
//  LoginView.swift
//  ChatApp
//
//  Created by Yashwant Sheshkar on 12/06/25.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var phoneNumber = ""
    @State private var isLoading = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                Spacer()
                
                Image(systemName: "message.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.blue)
                
                Text("Welcome to ChatApp")
                    .font(.title)
                    .fontWeight(.bold)
                
                VStack(spacing: 20) {
                    CustomTextField(
                        title: "Phone Number",
                        text: $phoneNumber,
                        placeholder: "Enter your phone number"
                    )
                    .keyboardType(.phonePad)
                    
                    Button(action: {
                        Task {
                            isLoading = true
                            await authViewModel.login(phoneNumber: phoneNumber)
                            isLoading = false
                        }
                    }) {
                        HStack {
                            if isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .scaleEffect(0.8)
                            }
                            Text("Login")
                                .fontWeight(.semibold)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.blue)
                        .cornerRadius(10)
                    }
                    .disabled(phoneNumber.isEmpty || isLoading)
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .padding()
            .alert("Error", isPresented: .constant(authViewModel.errorMessage != nil)) {
                Button("OK") {
                    authViewModel.errorMessage = nil
                }
            } message: {
                Text(authViewModel.errorMessage ?? "")
            }
            .sheet(isPresented: $authViewModel.showingProfileSetup) {
                ProfileSetupView()
                    .environmentObject(authViewModel)
            }
        }
    }
}
