# App Store Submission Checklist

## Pre-Submission Requirements

### ☐ 1. Apple Developer Account
- [ ] Enroll in Apple Developer Program ($99/year)
- [ ] Complete account setup
- [ ] Accept latest agreements
- [ ] Set up App Store Connect access

### ☐ 2. App Configuration

#### Bundle & Signing
- [ ] Unique bundle identifier (com.yourcompany.illadvised)
- [ ] Valid provisioning profile
- [ ] Code signing certificate installed
- [ ] Enable required capabilities in Xcode

#### Version & Build
- [ ] Version: 1.0
- [ ] Build number: 1 (increment for each submission)
- [ ] Set deployment target to iOS 15.0 minimum

### ☐ 3. Required Legal Documents

#### Privacy Policy
Create and host a privacy policy that covers:
- [ ] Camera usage and video recording
- [ ] Microphone/audio recording
- [ ] Location data collection (GPS, altitude)
- [ ] Motion sensor data collection
- [ ] Social media credential storage
- [ ] Data retention and deletion
- [ ] Third-party data sharing (if any)
- [ ] User rights (access, deletion, opt-out)

**Host on:** Personal website, GitHub Pages, or privacy policy generator

#### Terms of Service
- [ ] User agreement terms
- [ ] Acceptable use policy
- [ ] Account termination conditions
- [ ] Limitation of liability
- [ ] Indemnification clause

#### Safety Disclaimer
Required due to app nature:
```
WARNING: This application is designed for recording extreme sports 
and potentially dangerous activities. Use at your own risk. 

- Never use while driving or operating machinery
- Always wear appropriate safety equipment
- Follow all local laws and regulations
- Respect private property and restricted areas
- The developers assume no liability for injuries or damages

By using this app, you acknowledge and accept these risks.
```

### ☐ 4. App Store Assets

#### App Icon
- [ ] 1024x1024 PNG (no transparency, no alpha channel)
- [ ] Follow iOS icon design guidelines
- [ ] No text overlay (except brand name if part of logo)
- [ ] High resolution, clear, recognizable

#### Screenshots (Required for each device size)
**iPhone 6.7" (iPhone 14 Pro Max, 15 Pro Max)**
- [ ] 1290 x 2796 pixels
- [ ] Minimum 3 screenshots, maximum 10

**iPhone 6.5" (iPhone 11 Pro Max, XS Max)**
- [ ] 1242 x 2688 pixels
- [ ] Minimum 3 screenshots, maximum 10

**iPhone 5.5" (iPhone 8 Plus)**
- [ ] 1242 x 2208 pixels (optional but recommended)

**Screenshot Content:**
1. Main recording screen with camera view
2. Sensor overlay showing all data points
3. Settings screen with platform connections
4. Recording in action (if safe to demonstrate)
5. Feature highlights

#### App Preview Video (Optional but Recommended)
- [ ] 15-30 seconds
- [ ] Portrait orientation
- [ ] Shows core functionality
- [ ] No more than 500 MB
- [ ] MP4 or M4V format

### ☐ 5. App Store Listing

#### App Name
- [ ] "Ill Advised" or your chosen name
- [ ] Must be unique on App Store
- [ ] Maximum 30 characters
- [ ] Cannot include "test" or "demo"

#### Subtitle (Optional)
- [ ] Up to 30 characters
- [ ] Example: "Extreme Sports Recorder"

#### Description
Create compelling 4000-character description covering:
- [ ] What the app does (first 2 sentences critical)
- [ ] Key features with bullet points
- [ ] Supported platforms for streaming
- [ ] Sensor data tracked
- [ ] Safety warnings
- [ ] Use cases and target audience

**Example Opening:**
```
Capture your most extreme moments with real-time sensor data overlays. 
Ill Advised records from multiple cameras while displaying GPS, speed, 
altitude, orientation, and more—perfect for extreme sports enthusiasts.

KEY FEATURES:
• Dual-camera recording (front and rear)
• Live sensor data overlay (GPS, altitude, speed, acceleration)
• Direct streaming to social media platforms
• High-quality video recording
• Real-time compass and orientation display
• Barometric pressure and altitude tracking
• Step counter integration

...
```

#### Keywords
- [ ] Separate with commas
- [ ] No more than 100 characters total
- [ ] Be specific and relevant

**Suggested keywords:**
```
extreme sports,action camera,gopro,sensor data,gps tracking,
speed recorder,altitude meter,sports recording,live streaming,
stunt recording,adrenaline,adventure sports
```

#### Promotional Text (Optional)
- [ ] 170 characters
- [ ] Can be updated anytime without new review
- [ ] Appears above description

#### Support URL
- [ ] Valid HTTPS URL
- [ ] Contains support information
- [ ] Contact method included

#### Marketing URL (Optional)
- [ ] Product landing page
- [ ] Feature descriptions
- [ ] Promotional content

### ☐ 6. App Category & Rating

#### Primary Category
Choose one:
- [ ] Sports
- [ ] Photo & Video
- [ ] Entertainment
- [ ] Lifestyle

**Recommended:** Sports

#### Secondary Category (Optional)
- [ ] Photo & Video

#### Age Rating
Complete questionnaire honestly:

**Violence:** None (unless demonstrating stunts)
**Sexual Content:** None
**Profanity:** None
**Horror/Fear:** None
**Alcohol/Drugs/Tobacco:** None
**Mature/Suggestive Themes:** None
**Gambling:** None
**Medical/Treatment Info:** None

**Realistic Violence:** Potentially YES if showing dangerous stunts
- [ ] Infrequent/Mild or Frequent/Intense

**Unrestricted Web Access:** NO (no web browser)

**Expected Rating:** 12+ or 17+ (due to potential dangerous content)

### ☐ 7. Pricing & Availability

#### Pricing
- [ ] Free
- [ ] Or paid (set price tier)

#### Availability
- [ ] Select countries/regions
- [ ] Worldwide or specific markets

#### Pre-Order (Optional)
- [ ] Enable if you want to build anticipation
- [ ] Set release date

### ☐ 8. App Review Information

#### Contact Information
- [ ] First name
- [ ] Last name
- [ ] Phone number (with country code)
- [ ] Email address
- [ ] Responds within 24 hours

#### Demo Account (If Required)
For social media features:
- [ ] Username
- [ ] Password
- [ ] Additional notes for reviewer

**Note:** Reviewers need to test social media auth. Either:
1. Provide test accounts for platforms
2. Explain features work with user's own accounts
3. Include demo video showing functionality

#### Notes for Reviewer
```
IMPORTANT TESTING NOTES:

This app requires physical device testing for full functionality:
- Camera access (front and rear)
- GPS and location services
- Motion sensors (accelerometer, gyroscope, barometer)

SENSOR DATA:
All sensor data displays in real-time overlay during recording.
Move device around to see values update.

SOCIAL MEDIA:
Users authenticate with their own social media accounts.
Streaming requires valid platform credentials.
Test accounts: [provide if available]

SAFETY DISCLAIMER:
App includes safety warnings on first launch.
Intended for experienced extreme sports enthusiasts.
Not for use while driving.

DEMONSTRATION:
Record a short video in a safe environment to test all features.
Sensor data will update based on device movement.

Please contact [your email] with any questions.
```

### ☐ 9. App Capabilities & Permissions

#### In Info.plist
Verify all usage descriptions are clear and specific:
- [ ] NSCameraUsageDescription
- [ ] NSMicrophoneUsageDescription
- [ ] NSLocationWhenInUseUsageDescription
- [ ] NSMotionUsageDescription

#### Background Modes (If Needed)
- [ ] Audio (if recording audio in background)
- [ ] Location updates (if tracking location in background)

### ☐ 10. Technical Requirements

#### Testing
- [ ] Test on physical iPhone (not just simulator)
- [ ] Test on oldest supported iOS version (15.0)
- [ ] Test on multiple device sizes (mini, regular, Max)
- [ ] Test with poor GPS signal
- [ ] Test with limited storage
- [ ] Test with low battery
- [ ] Test camera switching
- [ ] Test sensor data accuracy
- [ ] Test recording start/stop
- [ ] Test permission denials
- [ ] Test airplane mode
- [ ] Test interruptions (phone call, etc.)

#### Performance
- [ ] App launches in under 20 seconds
- [ ] No crashes during normal use
- [ ] Smooth frame rate (30fps minimum)
- [ ] Reasonable battery consumption
- [ ] Memory usage is reasonable
- [ ] No excessive data usage

#### Build Requirements
- [ ] Archive build from Xcode
- [ ] Upload via Xcode or Transporter
- [ ] Include all required device types
- [ ] No compiler warnings (fix all warnings)
- [ ] Latest Xcode version used

### ☐ 11. Compliance

#### Export Compliance
- [ ] Determine if encryption is used
- [ ] File for export compliance if needed
- [ ] Usually "No" for standard iOS encryption

#### Content Rights
- [ ] You own all content in app
- [ ] No copyrighted material without permission
- [ ] No trademark violations

#### Third-Party Code
- [ ] List all libraries used
- [ ] Include proper licenses
- [ ] Attribute open source code

### ☐ 12. Additional Considerations

#### Safety Features
- [ ] Add in-app safety disclaimer on first launch
- [ ] Don't prompt again checkbox
- [ ] Emergency stop button (record button)
- [ ] Battery level indicator
- [ ] Storage space indicator
- [ ] Optional: Speed limit warning

#### Accessibility
Consider adding:
- [ ] VoiceOver support
- [ ] Dynamic Type support
- [ ] High contrast mode
- [ ] Accessibility labels on buttons

#### Localization (Optional)
- [ ] English (required)
- [ ] Additional languages (optional)
- [ ] Translate app name and description

## Submission Process

### Step 1: Create App in App Store Connect
1. Log into App Store Connect
2. My Apps → + → New App
3. Fill in basic information
4. Save

### Step 2: Upload Build
1. In Xcode: Product → Archive
2. Wait for archive to complete
3. Organizer window opens
4. Select archive → Distribute App
5. App Store Connect → Upload
6. Select signing options
7. Upload and wait for processing (15-60 min)

### Step 3: Complete App Information
1. App Store Connect → Your App
2. Fill in all sections marked with red dots
3. Add screenshots to each device size
4. Add description, keywords, etc.
5. Select uploaded build
6. Set pricing and availability
7. Fill in App Review Information
8. Save

### Step 4: Submit for Review
1. Review all information
2. Click "Submit for Review"
3. Confirm submission
4. Wait for review (typically 24-48 hours)

## After Submission

### ☐ Review Status Monitoring
- [ ] Check status daily in App Store Connect
- [ ] Respond to any reviewer questions within 24 hours
- [ ] Have phone available for potential reviewer calls

### ☐ If Rejected
- [ ] Read rejection reason carefully
- [ ] Address all issues mentioned
- [ ] Make necessary changes
- [ ] Test thoroughly
- [ ] Resubmit

Common rejection reasons:
- Incomplete functionality
- Crashes or bugs
- Missing demo account
- Unclear permissions
- Privacy policy issues
- Safety concerns not addressed

### ☐ If Approved
- [ ] Celebrate! 🎉
- [ ] App goes live automatically (or on scheduled date)
- [ ] Monitor reviews and ratings
- [ ] Respond to user feedback
- [ ] Plan for updates

## Post-Launch Checklist

### ☐ Marketing
- [ ] Share on social media
- [ ] Create product website
- [ ] Reach out to tech blogs
- [ ] Contact extreme sports communities
- [ ] Create demo videos
- [ ] Run ads (optional)

### ☐ User Support
- [ ] Set up support email
- [ ] Monitor App Store reviews
- [ ] Respond to user questions
- [ ] Collect feedback
- [ ] Track common issues

### ☐ Analytics
- [ ] Integrate App Store analytics
- [ ] Track downloads and usage
- [ ] Monitor crashes
- [ ] Identify popular features
- [ ] Plan improvements

### ☐ Updates
- [ ] Fix bugs reported by users
- [ ] Add requested features
- [ ] Improve performance
- [ ] Update for new iOS versions
- [ ] Refresh screenshots periodically

## Important Links

- [App Store Connect](https://appstoreconnect.apple.com/)
- [App Store Review Guidelines](https://developer.apple.com/app-store/review/guidelines/)
- [Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/)
- [App Store Marketing Resources](https://developer.apple.com/app-store/marketing/)
- [Common Rejection Reasons](https://developer.apple.com/app-store/review/rejections/)

## Timeline Estimate

- **Development:** 2-4 weeks (already done!)
- **Testing:** 1 week
- **Assets & Content:** 2-3 days
- **Submission Prep:** 1 day
- **Review Process:** 1-3 days
- **Total:** ~3-5 weeks from now to App Store

Good luck with your submission! 🚀
