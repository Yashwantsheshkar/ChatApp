//
//  ProfileSetupView.swift
//  ChatApp
//
//  Created by Yashwant Sheshkar on 12/06/25.
//

import SwiftUI

struct ProfileSetupView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var isLoading = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                Text("Complete Your Profile")
                    .font(.title)
                    .fontWeight(.bold)
                
                VStack(spacing: 20) {
                    CustomTextField(
                        title: "First Name",
                        text: $firstName,
                        placeholder: "Enter your first name"
                    )
                    
                    CustomTextField(
                        title: "Last Name",
                        text: $lastName,
                        placeholder: "Enter your last name"
                    )
                    
                    Button(action: {
                        Task {
                            isLoading = true
                            await authViewModel.updateProfile(
                                firstName: firstName,
                                lastName: lastName
                            )
                            isLoading = false
                        }
                    }) {
                        HStack {
                            if isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .scaleEffect(0.8)
                            }
                            Text("Continue")
                                .fontWeight(.semibold)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.blue)
                        .cornerRadius(10)
                    }
                    .disabled(firstName.isEmpty || lastName.isEmpty || isLoading)
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .interactiveDismissDisabled()
        }
    }
}
