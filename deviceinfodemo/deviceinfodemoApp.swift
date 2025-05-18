//
//  deviceinfodemoApp.swift
//  deviceinfodemo
//
//  Created by Johann Petzold on 17/05/2025.
//

import SwiftUI

@main
struct deviceinfodemoApp: App {
    
    @StateObject var deviceManager: DeviceManager = DeviceManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(deviceManager)
        }
    }
}
