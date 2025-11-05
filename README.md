# Ill Advised - iOS Extreme Sports Recording App

An iOS application that enables users to record and stream their extreme stunts with real-time sensor data overlays.

## Features

- **Dual Camera Recording**: Record from front and rear cameras (simultaneously on supported devices)
- **Real-Time Sensor Data Overlay**:
  - GPS coordinates (latitude/longitude)
  - Altitude (GPS and barometric)
  - Speed (MPH)
  - Compass heading and direction
  - Phone orientation (roll, pitch, yaw)
  - Acceleration (3-axis)
  - Rotation rate (3-axis)
  - Ambient pressure
  - Step counter
- **Social Media Streaming**: Stream directly to Facebook, Instagram, YouTube, TikTok, Twitch, and Twitter
- **Local Recording**: Save videos to device for later sharing

## Requirements

- iOS 15.0 or later
- iPhone with:
  - Camera (front and back)
  - GPS/Location Services
  - Motion sensors (accelerometer, gyroscope, magnetometer, barometer)
  - Microphone

## Setup Instructions

### 1. Xcode Project Setup

This project needs to be opened in Xcode. To create the Xcode project:

1. Open Xcode
2. Create a new iOS App project
3. Set the following:
   - Product Name: `Ill Advised`
   - Bundle Identifier: `com.yourcompany.illadvised`
   - Interface: Storyboard (or set up programmatic UI)
   - Language: Swift
4. Add all Swift files from the `IllAdvisedApp` directory to your project
5. Replace the Info.plist with the provided one

### 2. Social Media API Configuration

To enable social media streaming, you need to register your app with each platform and obtain API credentials:

#### Facebook/Instagram
1. Go to [Facebook Developers](https://developers.facebook.com/)
2. Create a new app
3. Add the "Facebook Login" product
4. Get your App ID and App Secret
5. Update `SocialMediaAuthManager.swift` with your credentials

#### YouTube
1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project
3. Enable YouTube Data API v3
4. Create OAuth 2.0 credentials
5. Add redirect URI: `illadvised://oauth-callback`
6. Update `SocialMediaAuthManager.swift` with your credentials

#### TikTok
1. Register at [TikTok for Developers](https://developers.tiktok.com/)
2. Create an app
3. Request video upload permissions
4. Update credentials in `SocialMediaAuthManager.swift`

#### Twitch
1. Register at [Twitch Developers](https://dev.twitch.tv/)
2. Create an application
3. Get Client ID and Client Secret
4. Update credentials in `SocialMediaAuthManager.swift`

#### Twitter
1. Go to [Twitter Developer Portal](https://developer.twitter.com/)
2. Create an app
3. Enable OAuth 2.0
4. Update credentials in `SocialMediaAuthManager.swift`

### 3. Update Client IDs

In `SocialMediaAuthManager.swift`, replace the placeholder client IDs:

```swift
private func getClientID(for platform: Platform) -> String {
    switch platform {
    case .facebook:
        return "YOUR_FACEBOOK_CLIENT_ID"
    case .instagram:
        return "YOUR_INSTAGRAM_CLIENT_ID"
    case .youtube:
        return "YOUR_YOUTUBE_CLIENT_ID"
    case .tiktok:
        return "YOUR_TIKTOK_CLIENT_ID"
    case .twitch:
        return "YOUR_TWITCH_CLIENT_ID"
    case .twitter:
        return "YOUR_TWITTER_CLIENT_ID"
    }
}
```

### 4. URL Scheme Configuration

Add the following to your Info.plist:

```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>illadvised</string>
        </array>
    </dict>
</array>
```

## App Store Submission Requirements

### 1. Privacy Policy
You must provide a privacy policy URL that explains:
- How location data is used
- How sensor data is collected
- How camera/microphone access is used
- How social media credentials are stored
- That the app is intended for extreme sports recording

### 2. App Store Connect Configuration
- Select category: Sports or Entertainment
- Age rating: 17+ (due to potential dangerous activities)
- Add screenshots showing the app in use
- Provide a demo video
- Write clear app description warning about safety

### 3. App Review Notes
Include the following in your App Review Information:
```
This app is designed for recording extreme sports activities with sensor data overlays.
Users are responsible for their own safety when using this app.
The app requires camera, microphone, location, and motion sensor access to function.
Social media streaming requires user authentication with their own accounts.
```

### 4. Safety Warning
Consider adding an in-app safety disclaimer on first launch:
```
WARNING: This app is designed for recording activities that may be dangerous.
Always prioritize your safety. Never use this app while driving or in situations
where it could distract you from safety-critical activities. Use protective equipment
and follow all safety guidelines for your activity.
```

## Dependencies

The app uses only Apple's native frameworks:
- AVFoundation (camera and audio)
- CoreLocation (GPS and compass)
- CoreMotion (sensors and motion data)
- Combine (reactive data binding)
- AuthenticationServices (OAuth)
- UIKit (UI)

For production RTMP streaming, consider integrating:
- [HaishinKit](https://github.com/shogo4405/HaishinKit.swift) - RTMP streaming library
- [VideoCore](https://github.com/jgh-/VideoCore) - Video encoding and streaming

## Known Limitations

1. **Multi-camera support**: Only available on iPhone XS/XR and later
2. **RTMP streaming**: Requires third-party library implementation (placeholders included)
3. **Battery usage**: Intensive sensor and camera usage will drain battery quickly
4. **Storage**: Video recordings can consume significant storage space

## Testing

Test the app thoroughly:
1. Test all permission requests
2. Verify sensor data updates in real-time
3. Test recording with various activities
4. Test camera switching
5. Test on different iPhone models
6. Test with low battery scenarios
7. Test with limited storage
8. Test social media authentication flows

## License

See LICENSE file for details.

## Disclaimer

This app is intended for responsible use by experienced individuals. The developers are not liable for any injuries, damages, or losses resulting from the use of this application. Always prioritize safety and follow local laws and regulations.
