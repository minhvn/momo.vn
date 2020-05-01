# momo_vn

## Getting Started
* Thank to  dangnhutyen1594@gmail.com
* Need register your application at momo business home page : https://business.momo.vn

### 1. Android set up:
* Step 1: Request Internet permission at  ```AndroidManifest.xml``` file:
```xml
<uses-permission android:name="android.permission.INTERNET" />
```

### 2. iOS set up:
* Step 1: Update ```Info.plist``` file  as below:
```xml
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleURLName</key>
    <string></string>
    <key>CFBundleURLSchemes</key>
    <array>
      <string>partnerSchemeId</string>
    </array>
  </dict>
</array>
<key>LSApplicationQueriesSchemes</key>
<array>
  <string>momo</string>
</array>
<key>NSAppTransportSecurity</key>
<dict>
  <key>NSAllowsArbitraryLoads</key>
  <true/>
</dict>
```

* Step 2: Define call back url for momo  at ```AppDelegate.swift ``` file:
```swift
import momo_vn
```
```swift
override func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        MoMoPayment.handleOpenUrl(url: url, sourceApp: sourceApplication!)
        return true
    }

override func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        MoMoPayment.handleOpenUrl(url: url, sourceApp: "")
        return true
    }
```

### See more setup at: https://developers.momo.vn/#/

## How to user plugin?
* View at example.

This project is a starting point for a Flutter
[plug-in package](https://flutter.dev/developing-packages/),
a specialized package that includes platform-specific implementation code for
Android and/or iOS.

For help getting started with Flutter, view our 
[online documentation](https://flutter.dev/docs), which offers tutorials, 
samples, guidance on mobile development, and a full API reference.
