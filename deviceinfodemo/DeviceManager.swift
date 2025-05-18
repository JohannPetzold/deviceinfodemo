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
    @Published var orientation: DeviceOrientation
    @Published var orientationDetail: DeviceOrientationDetail
    @Published var orientationChangePublisher: AnyCancellable?
    
    init() {
        deviceType = DeviceType.getType()
        orientation = DeviceOrientation.getDeviceOrientation()
        orientationDetail = DeviceOrientationDetail.getDeviceOrientationDetail()
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
    func updateOrientation(_ orientation: UIDeviceOrientation) {
        if orientation.isPortrait {
            self.orientation = .portrait
        } else if orientation.isLandscape {
            self.orientation = .landscape
        } else if orientation.isFlat {
            self.orientation = .flat
        } else {
            self.orientation = .unknown
        }
    }
    
    func updateOrientationDetail(_ orientation: UIDeviceOrientation) {
        switch orientation {
        case .unknown: self.orientationDetail = .unknown
        case .portrait: self.orientationDetail = .portrait
        case .portraitUpsideDown: self.orientationDetail = .portraitUpsideDown
        case .landscapeLeft: self.orientationDetail = .landscapeLeft
        case .landscapeRight: self.orientationDetail = .landscapeRight
        case .faceUp: self.orientationDetail = .faceUp
        case .faceDown: self.orientationDetail = .faceDown
        @unknown default: self.orientationDetail = .unknown
        }
    }
    
    func initOrientationPublisher() -> Void {
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        orientationChangePublisher = NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)
            .compactMap { notification in
                UIDevice.current.orientation
            }
            .sink { newOrientation in
                self.updateOrientation(newOrientation)
                self.updateOrientationDetail(newOrientation)
                logger.debug("New orientation: \(self.orientation.rawValue) (\(self.orientationDetail.rawValue))")
            }
    }
    
    func cancelOrientationPublisher() -> Void {
        orientationChangePublisher?.cancel()
        UIDevice.current.endGeneratingDeviceOrientationNotifications()
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

enum DeviceOrientation: String {
    case portrait
    case landscape
    case flat
    case unknown
    
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
        return .unknown
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
        return .unknown
        #endif
    }
}
