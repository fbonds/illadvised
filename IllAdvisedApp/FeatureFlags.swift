import Foundation

/// Feature flags for controlling optional functionality in the app
struct FeatureFlags {
    /// Enable social media streaming functionality
    /// When disabled, the app will only support local video recording
    /// Set to false to avoid needing social media developer accounts and OAuth setup
    static let enableSocialMediaStreaming = false
    
    /// Enable multi-camera support (requires iOS 13+)
    /// When disabled, only single camera recording is supported
    static let enableMultiCam = true
    
    /// Enable charity prompt on first launch
    static let enableCharityPrompt = true
    
    /// Enable intro animation on first launch
    static let enableIntroAnimation = true
}
