//
//  LoginViewModel.swift
//  Shotclock
//
//  Created by Mario Barrenechea on 3/25/25.
//

import Foundation

class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage: String? = nil
    @Published var isAuthenticated = false
    
    let appViewModel: AppViewModel
    
    init(appViewModel: AppViewModel){
        self.appViewModel = appViewModel
    }

    func login() {
        Task {
            NetworkManager.shared.sendRequest(
                endpoint: "/auth/api-auth-token/",
                method: "POST",
                body: [
                    "username": email,
                    "password": password
                ],
                responseType: AuthResponse.self,
                completion: { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let response):
                            print("Token: \(response.token)")
                            self.errorMessage = nil
                            self.appViewModel.setAuthenticated(response.token)
                        case .failure(let error):
                            print("Login failed: \(error.localizedDescription)")
                            self.errorMessage = "Invalid email or password."
                        }
                    }
                }
            )
        }
    }
}
