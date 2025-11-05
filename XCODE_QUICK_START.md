# Xcode Quick Start Guide

## Opening the Project

**Simply double-click:**
```
/Users/fletcher/code/illadvised/IllAdvised.xcodeproj
```

Or from command line:
```bash
cd /Users/fletcher/code/illadvised
open IllAdvised.xcodeproj
```

## Running in Simulator

1. **Select a simulator** from the device dropdown (top left)
   - Choose: iPhone 15 Pro (or any recent iPhone)

2. **Press the Play button** (▶️) or press `Cmd + R`

3. **Wait for build** - first build takes ~30 seconds

4. **App launches** in simulator!

## What You'll See

With the current feature flags (`FeatureFlags.swift`):
- ✅ Intro animation (falling phone) - **can be skipped for faster testing**
- ✅ Charity prompt - **can be skipped for faster testing**  
- ✅ Main camera interface with sensor overlay
- ❌ Social media streaming (disabled by feature flag)

## Expected Simulator Limitations

### Won't Work in Simulator:
- ❌ Actual camera (shows black screens or errors)
- ❌ Real GPS location (shows simulated location)
- ❌ Motion sensors (shows zeros or simulated data)
- ⚠️ Multi-cam (might not work - iOS Simulator limitation)

### Will Work in Simulator:
- ✅ UI layout and navigation
- ✅ Button interactions
- ✅ Settings screen
- ✅ Recording state changes (button color, labels)
- ✅ Intro animation
- ✅ Charity prompt flow

## Recommended Test Settings

### For Fast Simulator Testing

Edit `IllAdvisedApp/FeatureFlags.swift`:
```swift
static let enableSocialMediaStreaming = false  // Keep disabled
static let enableMultiCam = false              // Disable for simulator
static let enableCharityPrompt = false         // Skip to save time
static let enableIntroAnimation = false        // Skip to save time
```

Then clean build: `Product → Clean Build Folder` (or `Cmd + Shift + K`)

### For Full UX Testing
```swift
static let enableSocialMediaStreaming = false  // Keep disabled
static let enableMultiCam = false              // Disable for simulator  
static let enableCharityPrompt = true          // Test full flow
static let enableIntroAnimation = true         // Test full flow
```

## Testing on Real Device

**To test with actual camera/sensors:**

1. **Connect iPhone via USB**

2. **Trust computer** on phone (if first time)

3. **Select your iPhone** from device dropdown in Xcode

4. **Press Run** (▶️)

5. **Wait for code signing** (might need to sign in with Apple ID)
   - Xcode → Settings → Accounts → Add Apple ID

6. **On iPhone**: Settings → General → VPN & Device Management
   - Trust your developer certificate

7. **Run again** - app installs and launches on your phone!

### Recommended Device Settings
```swift
static let enableSocialMediaStreaming = false  // Not needed for testing
static let enableMultiCam = true               // Test dual camera!
static let enableCharityPrompt = true          // Full experience
static let enableIntroAnimation = true         // Full experience
```

## Common Issues & Fixes

### Issue: "No such module 'Combine'"
**Fix:** This shouldn't happen - Combine is built-in. If it does, clean build folder.

### Issue: Black camera screens
**Expected in simulator!** Camera doesn't work in iOS Simulator. Test on real device.

### Issue: "Signing for IllAdvised requires a development team"
**Fix:** 
1. Select project in navigator (blue icon at top)
2. Select "IllAdvised" target
3. Signing & Capabilities tab
4. Team dropdown → Add your Apple ID
5. Or select "Automatically manage signing"

### Issue: App crashes on launch
**Check:**
1. Console output in Xcode (bottom panel) for error messages
2. Make sure all Swift files compiled (check build log)
3. Clean build folder and retry

### Issue: Intro/charity screens won't go away
**Fix:** Reset the UserDefaults:
- While debugging, in Xcode console type:
  ```
  expr UserDefaults.standard.set(false, forKey: "HasSeenIntro")
  expr UserDefaults.standard.set(false, forKey: "HasSeenCharityPrompt")
  ```
- Or better: Disable in FeatureFlags.swift

### Issue: Can't tap through charity prompt
**Expected!** You must:
1. Check the acknowledgment checkbox
2. Then "I Understand" button enables
3. This is the designed behavior

## Project Structure in Xcode

```
IllAdvised
├── FeatureFlags.swift           ⚙️ Toggle features on/off
├── AppDelegate.swift             🚀 App lifecycle
├── SceneDelegate.swift           🪟 Window management
├── MainViewController.swift      📱 Main camera screen
├── IntroAnimationViewController  🎬 Falling phone intro
├── CharityPromptViewController   ❤️ Donation prompt
├── SettingsViewController        ⚙️ Settings screen
├── CameraManager.swift           📷 Camera handling
├── LocationManager.swift         📍 GPS/location
├── MotionManager.swift           🎢 Accelerometer/gyro
├── VideoRecordingManager.swift   🎥 Local recording
├── StreamingManager.swift        📡 Social media (disabled)
├── SocialMediaAuthManager.swift  🔐 OAuth (disabled)
└── SensorOverlayView.swift       📊 Data overlay UI
```

## Next Steps

### 1. Quick Visual Test (Simulator)
- Set all feature flags to `false` except what you're testing
- Run in simulator to see UI/layout
- Iterate on design

### 2. Real Device Test (iPhone)
- Enable full features in FeatureFlags.swift
- Test actual cameras and sensors
- Record a video to test full functionality

### 3. Enable Social Streaming (Later)
- Set `enableSocialMediaStreaming = true`
- Register OAuth apps for each platform
- Add credentials (see SOCIAL_MEDIA_SETUP.md when ready)

## Debugging Tips

### View Console Output
- `View → Debug Area → Show Debug Area` (or `Cmd + Shift + Y`)
- See print statements and errors here

### Set Breakpoints
- Click line number in code editor to add breakpoint
- App pauses when that line executes
- Inspect variables in debug area

### View Hierarchy
- While app running: Debug → View Debugging → Capture View Hierarchy
- See 3D exploded view of UI layers

### Simulate Location (Simulator)
- Debug → Simulate Location → Choose preset
- Test GPS functionality without moving

## Performance Notes

**First Build:** ~30-60 seconds (compiling all Swift files)  
**Subsequent Builds:** ~5-10 seconds (only changed files)  
**Clean Build:** ~30 seconds (recompiles everything)

## Ready to Go!

**Just double-click: `/Users/fletcher/code/illadvised/IllAdvised.xcodeproj`**

The project is fully configured with:
- ✅ All 14 Swift source files
- ✅ Info.plist with camera/location/motion permissions
- ✅ Build settings for iOS 15+
- ✅ Portrait orientation
- ✅ No external dependencies needed
- ✅ Feature flags for easy testing

**Have fun testing!** 🚀
