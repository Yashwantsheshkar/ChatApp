//
//  Extensions.swift
//  ChatApp
//
//  Created by Yashwant Sheshkar on 12/06/25.
//

import Foundation
import SwiftUI

extension UserDefaults {
    private enum Keys {
        static let authToken = "authToken"
        static let userData = "userData"
    }
    
    var authToken: String? {
        get { string(forKey: Keys.authToken) }
        set { set(newValue, forKey: Keys.authToken) }
    }
    
    var userData: User? {
        get {
            guard let data = data(forKey: Keys.userData) else { return nil }
            return try? JSONDecoder().decode(User.self, from: data)
        }
        set {
            if let user = newValue {
                let data = try? JSONEncoder().encode(user)
                set(data, forKey: Keys.userData)
            } else {
                removeObject(forKey: Keys.userData)
            }
        }
    }
}

extension Date {
    func timeAgoDisplay() -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: self, relativeTo: Date())
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
