//
//  ContentView.swift
//  Shotclock
//
//  Created by Mario Barrenechea on 1/3/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    
    var body: some View {
        NavigationStack {
            if appViewModel.isAuthenticated {
                HomeView()
            }
            else{
                LoginView(appViewModel: appViewModel)
            }
        }
    }
}

#Preview {
    ContentView()
}
