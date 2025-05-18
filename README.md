# 📱 deviceinfodemo

**deviceinfodemo** is a SwiftUI demo project that provides a simple way to detect the **device type** (iPhone, iPad, or Mac) and track the **current orientation**.

It includes a reusable `DeviceManager` as an `ObservableObject` that can be easily integrated into any SwiftUI app.

---

## 🔧 What it does

- Detects the **type of device** the app is running on (`iPhone`, `iPad`, or `Mac`)
- Monitors and updates the **current orientation** of the device in real time
- Works across iOS, iPadOS, and macOS

---

## 🧩 How it works

- `DeviceManager` is an `ObservableObject` that listens for orientation changes.
- It is initialized at app launch and injected into the SwiftUI environment using `.environmentObject(_:)`.
- The logic automatically adapts depending on the device platform.

---

## 🚀 Usage

To integrate into your project:

1. **Copy the `DeviceManager.swift` file** into your codebase.
2. In your `@main` App file:


```swift
@main
struct MyApp: App {
    @StateObject private var deviceManager = DeviceManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(deviceManager)
        }
    }
}
```

3. Access DeviceManager from any view via @EnvironmentObject:

```swift
@EnvironmentObject var deviceManager: DeviceManager
```

You can now use:

```swift
deviceManager.deviceType
deviceManager.orientation
deviceManager.orientationDetail
```

## 📦 Requirements

- SwiftUI
- iOS 15+, iPadOS 15+, or macOS 12+
- Xcode 15+

## 📄 License

MIT © Johann Petzold
