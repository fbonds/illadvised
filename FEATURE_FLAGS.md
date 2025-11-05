# Feature Flags Guide

This document explains the feature flag system in Ill Advised and how to use it.

## Overview

Feature flags allow you to enable/disable major features without modifying multiple files. This is particularly useful for:
- Development and testing in iOS Simulator
- Avoiding setup overhead for optional features
- Controlling which features ship in different app versions

## Configuration File

All feature flags are defined in `IllAdvisedApp/FeatureFlags.swift`:

```swift
struct FeatureFlags {
    static let enableSocialMediaStreaming = false
    static let enableMultiCam = true
    static let enableCharityPrompt = true
    static let enableIntroAnimation = true
}
```

## Available Feature Flags

### `enableSocialMediaStreaming`
**Default:** `false`  
**Purpose:** Controls all social media streaming functionality

When **disabled** (default):
- StreamingManager is not initialized
- Social media platform connections are hidden in Settings
- Only local video recording is available
- No OAuth setup required
- No social media developer accounts needed

When **enabled**:
- Full streaming capabilities to Facebook, Instagram, YouTube, TikTok, Twitch, Twitter
- Settings screen shows platform connection options
- Requires social media OAuth credentials (see SOCIAL_MEDIA_SETUP.md)

**Why disabled by default:**
- Allows testing in iOS Simulator without social media setup
- Avoids need for developer accounts on multiple platforms
- Reduces complexity during initial development
- Local recording is the core feature

### `enableMultiCam`
**Default:** `true`  
**Purpose:** Controls dual-camera recording (front + back simultaneously)

When **disabled**:
- Only single camera recording
- Better compatibility with older devices
- Reduced resource usage

When **enabled**:
- Records front and back camera simultaneously (requires iOS 13+)
- Creates the signature split-screen effect

### `enableCharityPrompt`
**Default:** `true`  
**Purpose:** Shows charity donation prompt on first launch

When **disabled**:
- App launches directly to camera interface
- Useful for development/testing

When **enabled**:
- Displays charity message and donation links
- Aligns with app's social commentary purpose

### `enableIntroAnimation`
**Default:** `true`  
**Purpose:** Shows falling phone animation on first launch

When **disabled**:
- Skips intro animation
- Faster testing iteration

When **enabled**:
- Shows "ill Advised" intro with falling phone animation
- Sets app's tone and theme

## How to Change Feature Flags

1. Open `IllAdvisedApp/FeatureFlags.swift`
2. Change the boolean value for the flag you want to toggle
3. Clean build folder (Product → Clean Build Folder in Xcode)
4. Rebuild and run

Example - enabling social media streaming:
```swift
static let enableSocialMediaStreaming = true  // Changed from false
```

## Testing Recommendations

### For iOS Simulator Testing
Recommended settings:
```swift
static let enableSocialMediaStreaming = false  // No OAuth in simulator
static let enableMultiCam = false              // May not work in simulator
static let enableCharityPrompt = false         // Skip for faster testing
static let enableIntroAnimation = false        // Skip for faster testing
```

### For Physical Device Testing (Core Features)
Recommended settings:
```swift
static let enableSocialMediaStreaming = false  // Focus on recording
static let enableMultiCam = true               // Test dual camera
static let enableCharityPrompt = true          // Test full UX flow
static let enableIntroAnimation = true         // Test full UX flow
```

### For Production Build (with Social Media)
Recommended settings:
```swift
static let enableSocialMediaStreaming = true   // Full features
static let enableMultiCam = true               // Full features
static let enableCharityPrompt = true          // Full UX
static let enableIntroAnimation = true         // Full UX
```

## Implementation Details

Feature flags are checked at runtime in:
- `MainViewController.swift` - Streaming manager initialization
- `SettingsViewController.swift` - Platform connection UI
- `MainViewController.viewDidAppear()` - Intro/charity flow

The flags use compile-time constants so the compiler can optimize out disabled code paths.

## Future Considerations

When you're ready to enable social media streaming:
1. Set `enableSocialMediaStreaming = true` in `FeatureFlags.swift`
2. Follow setup instructions in `SOCIAL_MEDIA_SETUP.md` (to be created)
3. Register OAuth apps for each platform
4. Add credentials to app configuration
5. Test authentication flow for each platform
6. Test streaming functionality

## Notes

- Feature flags are NOT persisted - they're compile-time configuration
- Changing flags requires rebuilding the app
- Users cannot toggle these flags - they're developer settings
- For user-facing settings, use `UserDefaults` instead
