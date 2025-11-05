# Quick Start Guide - Ill Advised iOS App

## TL;DR
This is a complete Swift iOS app for recording extreme sports with real-time sensor overlays. You need to open it in Xcode and configure social media API credentials.

## Setup in 5 Minutes

### Step 1: Create Xcode Project
```bash
1. Open Xcode
2. File → New → Project
3. Select "iOS App"
4. Product Name: "Ill Advised"
5. Interface: Storyboard
6. Language: Swift
7. Save to: /Users/fletcher/code/illadvised/
```

### Step 2: Add Source Files
```bash
1. In Xcode Project Navigator, delete the default ViewController.swift
2. Drag all .swift files from IllAdvisedApp folder into Xcode
3. Replace Info.plist with the one from IllAdvisedApp
4. Ensure all files are checked in Target Membership
```

### Step 3: Configure Build Settings
```
1. Select project in Navigator
2. Select target "Ill Advised"
3. General tab:
   - Deployment Target: iOS 15.0 or later
   - Bundle Identifier: com.yourcompany.illadvised
4. Signing & Capabilities:
   - Select your development team
   - Enable "Automatically manage signing"
```

### Step 4: Test Build
```bash
1. Select iPhone simulator (iPhone 14 or later recommended)
2. Press Cmd+B to build
3. Fix any build errors (usually import statements)
4. Press Cmd+R to run
```

### Step 5: Test on Device
```bash
1. Connect your iPhone via USB
2. Select your device in Xcode
3. Trust the device if prompted
4. Press Cmd+R to install
5. On iPhone: Settings → General → VPN & Device Management
6. Trust your developer certificate
7. Open the app
8. Grant all permissions (Camera, Location, Motion)
```

## Testing the App

### Basic Recording Test
1. Launch app
2. Grant camera permission
3. Grant location permission
4. Grant motion permission
5. Point camera at something
6. Tap red record button
7. Move around to see sensor data update
8. Tap button again to stop
9. Video is saved to temporary directory

### Sensor Data Test
Move your phone around and watch the overlay update:
- **GPS**: Walk outside to see coordinates change
- **Altitude**: Go upstairs to see altitude increase
- **Speed**: Walk/run to see speed in MPH
- **Heading**: Rotate to see compass direction
- **Orientation**: Tilt phone to see roll/pitch/yaw
- **Acceleration**: Shake phone to see acceleration
- **Rotation**: Spin phone to see rotation rate
- **Pressure**: Changes with weather and altitude
- **Steps**: Walk around to see step count

### Settings Test
1. Tap gear icon (bottom left)
2. See list of social platforms
3. Tap a platform to authenticate
4. OAuth web view should appear
5. (Won't work without API credentials)

## Configuring Social Media (Optional)

If you want streaming to work, you need to register with each platform:

### Facebook/Instagram
```
1. Go to developers.facebook.com
2. Create app → Consumer
3. Add Facebook Login product
4. Get App ID from Settings → Basic
5. In SocialMediaAuthManager.swift:
   Replace "YOUR_FACEBOOK_CLIENT_ID" with your App ID
```

### YouTube
```
1. Go to console.cloud.google.com
2. Create new project
3. Enable "YouTube Data API v3"
4. Create OAuth 2.0 Client ID
5. Add redirect URI: illadvised://oauth-callback
6. Get Client ID
7. Replace "YOUR_YOUTUBE_CLIENT_ID" in code
```

### Others (TikTok, Twitch, Twitter)
Follow similar process on their developer portals.

## Common Issues & Fixes

### Issue: "Undefined symbol" errors
**Fix:** Make sure all .swift files are in the target:
1. Select file in Navigator
2. Show File Inspector (right panel)
3. Check "Ill Advised" under Target Membership

### Issue: Camera shows black screen
**Fix:** Check Info.plist has camera usage description
```xml
<key>NSCameraUsageDescription</key>
<string>This app requires camera access...</string>
```

### Issue: Location not updating
**Fix:** 
- Test on real device (simulator has limited location)
- Make sure location permission is granted
- Go outside for better GPS signal

### Issue: App crashes on launch
**Fix:** Check console for error message
- Usually missing permission keys in Info.plist
- Or missing file in build target

### Issue: "Module not found" errors
**Fix:** No external dependencies required
- All imports should be Apple frameworks
- Make sure deployment target is iOS 15.0+

### Issue: Can't install on device
**Fix:** 
- Select your team in Signing & Capabilities
- Change bundle identifier to unique value
- Trust developer certificate on device

## Project Structure Quick Reference

```
Key Files:
├── AppDelegate.swift          → App lifecycle
├── SceneDelegate.swift        → Window setup
├── MainViewController.swift   → Main screen (START HERE)
├── CameraManager.swift        → Camera control
├── LocationManager.swift      → GPS tracking
├── MotionManager.swift        → Sensors
├── VideoRecordingManager.swift → Save videos
├── SensorOverlayView.swift    → Display overlay
├── SettingsViewController.swift → Settings screen
└── Info.plist                 → Permissions
```

## Customization Ideas

### Change Overlay Colors
In `SensorOverlayView.swift`, line ~20:
```swift
stack.backgroundColor = UIColor.black.withAlphaComponent(0.6)
// Change to:
stack.backgroundColor = UIColor.red.withAlphaComponent(0.4)
```

### Change Record Button Color
In `MainViewController.swift`, line ~51:
```swift
button.backgroundColor = .red
// Change to:
button.backgroundColor = .systemGreen
```

### Add More Sensor Data
In `MotionManager.swift`, add new @Published properties:
```swift
@Published var myNewSensor: Double = 0.0
```

Then update UI in `SensorOverlayView.swift`

### Change Video Quality
In `VideoRecordingManager.swift`, line ~27:
```swift
AVVideoAverageBitRateKey: 6_000_000,
// Change to 10 Mbps:
AVVideoAverageBitRateKey: 10_000_000,
```

## Debugging Tips

### View Logs
In Xcode:
1. Run app
2. Open Debug Area (Cmd+Shift+Y)
3. Watch console for print statements

### Check Sensor Values
Add breakpoint in `SensorOverlayView.swift`:
```swift
.sink { [weak self] lat, lon in
    print("GPS: \(lat), \(lon)") // Add this
    self?.gpsLabel.text = ...
}
```

### Inspect Video Output
After recording, print file location:
```swift
print("Video saved: \(url.path)")
```
Then copy to Mac via Xcode → Devices and Simulators

## Performance Testing

### Monitor Frame Rate
In `CameraManager.swift`, add to captureOutput:
```swift
func captureOutput(...) {
    print("Frame received: \(Date())")
}
```

### Check Memory Usage
1. Run app in Xcode
2. Click Debug Navigator (Cmd+7)
3. Select Memory
4. Watch for leaks or spikes

### Battery Impact
Test on device:
1. Fully charge iPhone
2. Record for 1 hour
3. Note battery % used
4. Should be ~30-50% per hour

## Next Steps

1. ✅ Build and run basic app
2. ✅ Test recording functionality  
3. ✅ Verify sensor data updates
4. ⬜ Add social media credentials
5. ⬜ Implement RTMP streaming (requires HaishinKit)
6. ⬜ Add video overlay rendering
7. ⬜ Design app icon
8. ⬜ Add safety disclaimer screen
9. ⬜ Test on multiple devices
10. ⬜ Prepare for App Store

## Resources

- [Apple AVFoundation Docs](https://developer.apple.com/av-foundation/)
- [Core Motion Guide](https://developer.apple.com/documentation/coremotion)
- [Core Location Guide](https://developer.apple.com/documentation/corelocation)
- [HaishinKit for RTMP](https://github.com/shogo4405/HaishinKit.swift)
- [App Store Review Guidelines](https://developer.apple.com/app-store/review/guidelines/)

## Support

For issues or questions:
1. Check README.md for detailed documentation
2. Check PROJECT_STRUCTURE.md for architecture details
3. Read inline code comments
4. Review Apple's documentation for frameworks used

## Safety Reminder

This app is for recording potentially dangerous activities. Always include safety warnings and disclaimers in your app. Consider adding:
- Launch screen warning
- Terms of service
- Liability waiver
- Safety tips section

Good luck with your extreme sports app! 🎥 🏂 🚀
