# Ill Advised - Project Structure

## Overview
This iOS application enables users to record extreme sports activities with real-time sensor data overlays and social media streaming capabilities.

## File Structure

```
illadvised/
├── LICENSE
├── README.md
├── .gitignore
├── PROJECT_STRUCTURE.md (this file)
└── IllAdvisedApp/
    ├── Info.plist                      # App configuration and permissions
    ├── AppDelegate.swift               # App lifecycle management
    ├── SceneDelegate.swift             # Scene lifecycle and window setup
    ├── MainViewController.swift        # Main app interface and recording controls
    ├── SettingsViewController.swift    # Settings and social media connections
    ├── CameraManager.swift             # Camera capture and multi-cam support
    ├── LocationManager.swift           # GPS, altitude, heading tracking
    ├── MotionManager.swift             # Accelerometer, gyroscope, pressure sensors
    ├── VideoRecordingManager.swift     # Local video recording with overlays
    ├── StreamingManager.swift          # RTMP streaming (needs third-party SDK)
    ├── SocialMediaAuthManager.swift    # OAuth authentication for platforms
    └── SensorOverlayView.swift         # Real-time sensor data display overlay
```

## Architecture

### Core Components

#### 1. **CameraManager** (`CameraManager.swift`)
- Manages AVFoundation capture sessions
- Supports single camera and multi-camera (iPhone XS+)
- Handles camera switching (front/rear)
- Provides video/audio sample buffers for recording/streaming

**Key Features:**
- Multi-cam support detection
- Authorization handling
- Preview layer creation
- Real-time video/audio output

#### 2. **LocationManager** (`LocationManager.swift`)
- Uses Core Location for GPS tracking
- Provides: latitude, longitude, altitude, speed, heading
- Converts speed to MPH
- Updates in real-time during recording

**Published Properties:**
- `latitude`, `longitude` (Double)
- `altitude` (meters)
- `speedMPH` (calculated from m/s)
- `heading` (true north)

#### 3. **MotionManager** (`MotionManager.swift`)
- Uses Core Motion for device sensors
- Tracks orientation (roll, pitch, yaw)
- Monitors acceleration (3-axis)
- Measures rotation rate (3-axis)
- Reads barometric pressure
- Counts steps via pedometer

**Published Properties:**
- `roll`, `pitch`, `yaw` (degrees)
- `accelerationX/Y/Z` (g-force)
- `rotationRateX/Y/Z` (degrees/second)
- `pressure` (kPa)
- `relativeAltitude` (meters)
- `stepCount` (integer)

#### 4. **VideoRecordingManager** (`VideoRecordingManager.swift`)
- Uses AVAssetWriter for MP4 video creation
- Encodes H.264 video at 6 Mbps
- Encodes AAC audio at 128 kbps
- Supports overlay rendering on video frames
- Saves to temporary directory

**Key Methods:**
- `startRecording(size:)` - Begin recording
- `stopRecording(completion:)` - End and save
- `appendVideoBuffer(_:withOverlay:)` - Add video frame
- `appendAudioBuffer(_:)` - Add audio sample

#### 5. **StreamingManager** (`StreamingManager.swift`)
- RTMP streaming framework (placeholder implementation)
- Needs third-party SDK like HaishinKit for production
- Handles video/audio encoding for streaming
- Manages RTMP connection lifecycle

**Note:** Current implementation is a placeholder. For production, integrate:
- [HaishinKit.swift](https://github.com/shogo4405/HaishinKit.swift) for RTMP
- Or use platform-specific SDKs (Facebook Live API, YouTube Live API, etc.)

#### 6. **SocialMediaAuthManager** (`SocialMediaAuthManager.swift`)
- OAuth 2.0 authentication for 6 platforms
- Stores credentials securely in UserDefaults (should use Keychain in production)
- Provides streaming URLs and keys
- Uses ASWebAuthenticationSession for OAuth flow

**Supported Platforms:**
- Facebook Live
- Instagram Live
- YouTube Live
- TikTok Live
- Twitch
- Twitter (Periscope)

**Security Note:** Move credential storage to Keychain before production.

#### 7. **SensorOverlayView** (`SensorOverlayView.swift`)
- Real-time UI overlay displaying all sensor data
- Uses Combine for reactive updates
- Semi-transparent black background
- Positioned in top corner of camera view

**Displayed Data:**
- GPS coordinates (6 decimal places)
- Altitude (GPS + relative)
- Speed (MPH)
- Heading with cardinal direction
- Orientation angles
- Acceleration values
- Rotation rates
- Pressure
- Step count

#### 8. **MainViewController** (`MainViewController.swift`)
- Main app interface
- Camera preview with full-screen display
- Recording controls (start/stop)
- Camera switch button
- Settings button
- Status indicator
- Permission handling

**User Flow:**
1. Request camera/location/motion permissions
2. Setup camera and sensors
3. Display preview with overlay
4. Record video with button
5. Access settings for social media

#### 9. **SettingsViewController** (`SettingsViewController.swift`)
- Platform connection management
- OAuth authentication flow
- Connected status display
- Disconnect functionality
- App information

## Data Flow

```
Camera → CameraManager → Sample Buffers
                            ↓
Location → LocationManager → Published Values → SensorOverlayView
                            ↓                         ↓
Motion → MotionManager → Published Values → Overlay Rendering
                            ↓
                    VideoRecordingManager → MP4 File
                            ↓
                    StreamingManager → RTMP Stream
```

## Combine Publishers

The app uses Combine framework for reactive data binding:

```swift
LocationManager.$latitude
MotionManager.$roll
RecordingManager.$isRecording
StreamingManager.$isStreaming
```

All sensor data is published and automatically updates the UI through Combine subscriptions.

## Permissions Required

Defined in `Info.plist`:
- **Camera** (`NSCameraUsageDescription`)
- **Microphone** (`NSMicrophoneUsageDescription`)
- **Location** (`NSLocationWhenInUseUsageDescription`)
- **Motion** (`NSMotionUsageDescription`)

## Next Steps for Production

### 1. Xcode Project Setup
- Open Xcode and create new iOS project
- Add all Swift files
- Configure build settings
- Set deployment target to iOS 15.0+

### 2. RTMP Streaming Implementation
Choose one approach:
- **Option A:** Integrate HaishinKit.swift via CocoaPods/SPM
- **Option B:** Use platform-specific SDKs
- **Option C:** Build custom RTMP implementation

### 3. Security Enhancements
- Move credentials from UserDefaults to Keychain
- Implement certificate pinning for API calls
- Add encryption for stored data
- Sanitize user inputs

### 4. Video Overlay Rendering
Current implementation has placeholder overlay support. Enhance:
- Use Core Image for efficient compositing
- Add vImage for performance
- Implement Metal for GPU acceleration
- Render sensor data directly onto video frames

### 5. Social Media API Integration
For each platform, implement:
- Complete OAuth flow
- Token refresh logic
- API calls for stream keys
- Live streaming endpoints
- Error handling and retry logic

### 6. Testing Requirements
- Unit tests for each manager
- UI tests for recording flow
- Integration tests for streaming
- Device testing on multiple iPhone models
- Battery/performance profiling

### 7. App Store Preparation
- Create App Store Connect account
- Design app icon (1024x1024)
- Capture screenshots for all device sizes
- Write app description
- Create privacy policy
- Add safety warnings
- Submit for review

## Performance Considerations

### Battery Usage
- Camera, GPS, and sensors are power-intensive
- Recommend users keep device plugged in during use
- Consider battery level warnings

### Storage Management
- Videos can be several GB per hour
- Implement storage check before recording
- Add option to delete old recordings
- Show available storage in settings

### Memory Management
- Sample buffers must be released properly
- Use autoreleasepool for video processing
- Profile memory usage with Instruments
- Handle memory warnings gracefully

### Frame Rate
- Target 30fps for smooth recording
- Drop frames if processing can't keep up
- Monitor frame drop count
- Adjust quality based on device capability

## Known Limitations

1. Multi-camera only works on iPhone XS/XR and newer
2. RTMP streaming requires third-party library
3. Some platforms (Instagram) restrict live API access
4. Barometric altitude may drift over time
5. GPS accuracy varies by environment
6. Background recording is limited by iOS

## Dependencies

**Current:** None (all Apple frameworks)

**Recommended for Production:**
- HaishinKit.swift (RTMP streaming)
- KeychainAccess (secure credential storage)
- SnapKit (UI layout helper)

## Code Style

- Swift 5.9+
- Property wrappers: `@Published`, `@objc`
- Combine for reactive programming
- Protocol-oriented where appropriate
- Delegation pattern for callbacks
- Weak references to avoid retain cycles

## License

See LICENSE file.
