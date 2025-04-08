//
//  AppConfig.swift
//  Shotclock
//
//  Created by Mario Barrenechea on 9/8/22.
//

import Foundation

struct AppConfig {
    static let shared = AppConfig()
    private var config: [String: Any] = [:]
    
    private init(){
        let envName: String
        #if DEV
        envName = "dev"
        print("Running in DEV mode")
        #elseif STAGE
        envName = "stage"
        print("Running in STAGE mode")
        #elseif PROD
        envName = "prod"
        print("Running in PRODUCTION mode")
        #else
        envName = ""
        print("Couldn't detect MODE!!!")
        #endif
        
        guard let baseURL = Bundle.main.url(forResource: "base", withExtension: "plist"),
            // Load ENV-specific plist (Dev, Staging, Prod)
            let envURL = Bundle.main.url(forResource: envName, withExtension: "plist"),
              
            // Read both files as data
            let baseData = try? Data(contentsOf: baseURL),
            let envData = try? Data(contentsOf: envURL),
              
            // Convert data -> dictionary format
            let baseDict = try? PropertyListSerialization.propertyList(from: baseData, format: nil) as? [String: Any],
            let envDict = try? PropertyListSerialization.propertyList(from: envData, format: nil) as? [String: Any]
        else {
            fatalError("❌ Failed to load or parse plist files")
        }
        
        // Merge: if keys conflict, use the ENV-SPECIFIC value
        self.config = baseDict.merging(envDict) { _, new in new }
    }
    
    func string(_ key: String) -> String {
        config[key] as? String ?? ""
    }
    
    func bool(_ key: String) -> Bool {
        config[key] as? Bool ?? false
    }
}
