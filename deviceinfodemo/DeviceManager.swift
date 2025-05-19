//
//  DeviceManager.swift
//  deviceinfodemo
//
//  Created by Johann Petzold on 17/05/2025.
//

import Foundation
import SwiftUI
import Combine
import OSLog

fileprivate let logger: Logger = .init(subsystem: "DeviceInfoDemo", category: "DeviceManager")

class DeviceManager: ObservableObject {
    
    var deviceType: DeviceType
    @Published var interfaceOrientation: InterfaceOrientation
    @Published var deviceOrientation: DeviceOrientation
    @Published var deviceOrientationDetail: DeviceOrientationDetail
    
    var cancellables: Set<AnyCancellable> = []
    
    init() {
        deviceType = DeviceType.getType()
        interfaceOrientation = InterfaceOrientation.getInterfaceOrientation()
        deviceOrientation = DeviceOrientation.getDeviceOrientation()
        deviceOrientationDetail = DeviceOrientationDetail.getDeviceOrientationDetail()
        logger.debug("Type: \(self.deviceType.rawValue)")
        #if os(iOS)
        initOrientationPublisher()
        #endif
    }
    
    deinit {
        #if os(iOS)
        cancelOrientationPublisher()
        #endif
    }
    
    #if os(iOS)
    private func initOrientationPublisher() -> Void {
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)
            .compactMap { _ -> (UIInterfaceOrientation, UIDeviceOrientation)? in
                guard let interfaceOrientation = UIApplication.shared.connectedScenes
                    .compactMap({ $0 as? UIWindowScene })
                    .first?.interfaceOrientation else { return nil }
                let deviceOrientation = UIDevice.current.orientation
                return (interfaceOrientation, deviceOrientation)
            }
            .sink { [weak self] interfaceOrientation, deviceOrientation in
                guard let self else { return }
                self.updateInterfaceOrientation(interfaceOrientation)
                self.updateDeviceOrientation(deviceOrientation)
                logger.debug("Interface: \(self.interfaceOrientation.rawValue), Device: \(self.deviceOrientation.rawValue) (\(self.deviceOrientationDetail.rawValue))")
            }
            .store(in: &cancellables)
    }
    
    func cancelOrientationPublisher() -> Void {
        cancellables.removeAll()
        UIDevice.current.endGeneratingDeviceOrientationNotifications()
    }
    
    private func updateInterfaceOrientation(_ orientation: UIInterfaceOrientation) {
        switch orientation {
        case .portrait: self.interfaceOrientation = .portrait
        case .portraitUpsideDown: self.interfaceOrientation = .portraitUpsideDown
        case .landscapeLeft: self.interfaceOrientation = .landscapeLeft
        case .landscapeRight: self.interfaceOrientation = .landscapeRight
        default: self.interfaceOrientation = .unknown
        }
    }
    
    private func updateDeviceOrientation(_ orientation: UIDeviceOrientation) {
        switch orientation {
        case .portrait:
            updateOrientationValues(correctOrientation: orientation.isPortrait, orientation: .portrait, detailOrientation: .portrait)
        case .portraitUpsideDown:
            updateOrientationValues(correctOrientation: orientation.isPortrait, orientation: .portrait, detailOrientation: .portraitUpsideDown)
        case .landscapeLeft:
            updateOrientationValues(correctOrientation: orientation.isLandscape, orientation: .landscape, detailOrientation: .landscapeLeft)
        case .landscapeRight:
            updateOrientationValues(correctOrientation: orientation.isLandscape, orientation: .landscape, detailOrientation: .landscapeRight)
        case .faceUp:
            updateOrientationValues(correctOrientation: orientation.isFlat, orientation: .flat, detailOrientation: .faceUp)
        case .faceDown:
            updateOrientationValues(correctOrientation: orientation.isFlat, orientation: .flat, detailOrientation: .faceDown)
        default:
            self.deviceOrientationDetail = .unknown
        }
    }
    
    private func updateOrientationValues(correctOrientation: Bool, orientation: DeviceOrientation, detailOrientation: DeviceOrientationDetail) {
        self.deviceOrientationDetail = detailOrientation
        if correctOrientation {
            self.deviceOrientation = orientation
        }
    }
    #endif
}

enum DeviceType: String {
    case iPhone
    case iPad
    case mac
    
    static func getType() -> DeviceType {
        #if os(iOS)
        switch UIDevice.current.localizedModel {
        case "iPhone": return .iPhone
        case "iPad": return .iPad
        default: return .iPhone
        }
        #elseif os(macOS)
        return .mac
        #endif
    }
}

enum InterfaceOrientation : String {
    case unknown
    case portrait
    case portraitUpsideDown
    case landscapeLeft
    case landscapeRight
    case none
    
    static func getInterfaceOrientation() -> InterfaceOrientation {
        #if os(iOS)
        guard let orientation = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first?.interfaceOrientation else {
            return .unknown
        }
        switch orientation {
        case .portrait: return .portrait
        case .portraitUpsideDown: return .portraitUpsideDown
        case .landscapeLeft: return .landscapeLeft
        case .landscapeRight: return .landscapeRight
        default: return .unknown
        }
        #elseif os(macOS)
        return .none
        #endif
    }
}

enum DeviceOrientation: String {
    case portrait
    case landscape
    case flat
    case unknown
    case none
    
    static func getDeviceOrientation() -> DeviceOrientation {
        #if os(iOS)
        let orientation = UIDevice.current.orientation
        if orientation.isPortrait {
            return .portrait
        } else if orientation.isLandscape {
            return .landscape
        } else if orientation.isFlat {
            return .flat
        } else {
            return .unknown
        }
        #elseif os(macOS)
        return .none
        #endif
    }
}

enum DeviceOrientationDetail: String {
    case portrait
    case portraitUpsideDown
    case landscapeLeft
    case landscapeRight
    case faceUp
    case faceDown
    case unknown
    case none
    
    static func getDeviceOrientationDetail() -> DeviceOrientationDetail {
        #if os(iOS)
        let orientation = UIDevice.current.orientation
        switch orientation {
        case .unknown: return .unknown
        case .portrait: return .portrait
        case .portraitUpsideDown: return .portraitUpsideDown
        case .landscapeLeft: return .landscapeLeft
        case .landscapeRight: return .landscapeRight
        case .faceUp: return .faceUp
        case .faceDown: return .faceDown
        @unknown default: return .unknown
        }
        #elseif os(macOS)
        return .none
        #endif
    }
}
