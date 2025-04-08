//
//  AppViewModel.swift
//  Shotclock
//
//  Created by Mario Barrenechea on 4/8/25.
//
import Foundation

class AppViewModel: ObservableObject {
    @Published var isAuthenticated: Bool = false
    @Published var access_token: String? = nil
    
    func setAuthenticated(_ token: String){
        self.access_token = token
        self.isAuthenticated = true
    }
    
    func logOut() {
        self.access_token = nil
        self.isAuthenticated = false
    }
}
