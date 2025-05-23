//
//  ContentView.swift
//  deviceinfodemo
//
//  Created by Johann Petzold on 17/05/2025.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var deviceManager: DeviceManager
    
    var body: some View {
        VStack(spacing: 32) {
            
            Image(systemName: deviceImageName())
                .resizable()
                .scaledToFit()
                .frame(width: 248, height: 196)
                .foregroundStyle(.tint)
            
            VStack(spacing: 8) {
                Text("Interface: \(deviceManager.interfaceOrientation.rawValue)")
                    .bold()
                
                Text("Device: \(deviceManager.deviceOrientation.rawValue) (\(deviceManager.deviceOrientationDetail.rawValue))")
                    .bold()
            }
            
        }
    }
    
    private func deviceImageName() -> String {
        switch deviceManager.deviceType {
        case .iPhone: return "iphone"
        case .iPad: return "ipad"
        case .mac: return "macbook"
        }
    }
}

#Preview {
    ContentView()
}
