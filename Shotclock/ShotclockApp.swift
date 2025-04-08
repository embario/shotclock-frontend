//
//  ShotclockApp.swift
//  Shotclock
//
//  Created by Mario Barrenechea on 8/21/22.
//

import SwiftUI

@main
struct ShotclockApp: App {
    
    @StateObject var appViewModel = AppViewModel()
    
    init() {
        _ = AppConfig.shared
    }

    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(appViewModel)
        }
    }
}
