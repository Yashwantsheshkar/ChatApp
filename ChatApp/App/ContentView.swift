//
//  ContentView.swift
//  ChatApp
//
//  Created by Yashwant Sheshkar on 12/06/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        ZStack {
            if authViewModel.isLoading {
                SplashView()
            } else if authViewModel.isAuthenticated {
                ChatListView()
            } else {
                LoginView()
            }
        }
        .onAppear {
            authViewModel.checkAuthenticationStatus()
        }
    }
}
