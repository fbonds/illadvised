# Ill Advised - Web Demo

## Quick Start

This is a **web-based demo** of the Ill Advised iOS app that simulates the full user experience without requiring Xcode or an iOS device.

### To Run Locally:

**Option 1: Simple Python Server (Easiest)**
```bash
cd /Users/fletcher/code/illadvised/web-demo
python3 -m http.server 8000
```
Then open: http://localhost:8000

**Option 2: Using Node.js**
```bash
cd /Users/fletcher/code/illadvised/web-demo
npx http-server -p 8000
```
Then open: http://localhost:8000

**Option 3: Using PHP**
```bash
cd /Users/fletcher/code/illadvised/web-demo
php -S localhost:8000
```
Then open: http://localhost:8000

**Option 4: Just open the file**
For basic testing, you can simply open `index.html` directly in your browser:
```bash
open index.html
```
(Note: Camera access won't work with file:// protocol)

---

## What This Demo Shows

### ✅ Full User Experience
1. **Charity Prompt** (First Launch)
   - Shows on first visit
   - Lists all 8 charities with real donation links
   - Requires acknowledgment checkbox
   - "I Understand" button disabled until checked

2. **Main Recording Screen**
   - Simulated camera feed (or shows placeholder)
   - Real-time sensor data overlay (simulated)
   - Record button (tap to start/stop)
   - Camera switch button
   - Settings button

3. **Settings Screen**
   - Social media platform list
   - Connection status (shows "Not Connected" in demo)
   - About section
   - Reset charity prompt button (for testing)

### 📊 Simulated Sensor Data

The demo simulates all 9 sensor readings:
- **GPS**: Coordinates that drift slightly
- **Altitude**: GPS altitude + relative altitude
- **Speed**: Simulates walking (0-5 MPH) or falling (0-55 MPH when recording)
- **Heading**: Rotating compass with cardinal directions
- **Orientation**: Roll, pitch, yaw angles
- **Acceleration**: 3-axis g-force measurements
- **Rotation**: 3-axis rotation rates
- **Pressure**: Barometric pressure
- **Steps**: Incremental step counter

### 🎬 "Recording" Mode

When you tap the record button:
- Button changes appearance (pulses)
- Status changes to "Recording" in red
- Sensor data updates more frequently
- Values become more dramatic (simulating phone destruction physics):
  - Speed increases (up to 55 MPH)
  - Altitude changes rapidly
  - Orientation spins wildly
  - Acceleration shows high g-forces
  - Rotation rates spike

This gives you a sense of what the data would look like during an actual phone drop/throw.

---

## Features Demonstrated

### ✅ Working Features
- Charity prompt with real donation links
- Checkbox acknowledgment requirement
- LocalStorage persistence (won't show prompt again after acknowledging)
- Simulated sensor data with realistic physics
- Recording state changes
- Camera switch animation
- Settings screen navigation
- Reset functionality for testing

### ⚠️ Demo Limitations
- Camera feed is simulated (gradient background + placeholder)
- Sensor data is mathematically generated, not from real sensors
- Social media platforms show as "Not Connected" (OAuth not implemented in demo)
- No actual video recording (just simulates the state)
- No streaming (framework exists in full app)

---

## Testing the Charity Prompt

### First Time Experience
1. Open the demo
2. See full charity prompt
3. Try to click "I Understand" - it's disabled
4. Check the acknowledgment checkbox
5. "I Understand" button becomes enabled
6. Click to continue to main screen

### Testing Again
To see the charity prompt again:
1. Go to Settings (gear icon)
2. Click "Reset Charity Prompt (for testing)"
3. Page reloads and shows charity prompt again

Or manually:
1. Open browser DevTools (F12)
2. Go to Console
3. Type: `localStorage.clear()`
4. Reload page

---

## Viewing on Mobile

### iOS Safari
1. Start the local server
2. Find your computer's local IP address:
   ```bash
   ifconfig | grep "inet " | grep -v 127.0.0.1
   ```
3. On your iPhone, open Safari
4. Go to: `http://[YOUR_IP]:8000`
5. You'll see the mobile-optimized version

### Android Chrome
Same process as iOS, but use Chrome browser

### Benefits of Mobile Testing
- See actual phone screen size
- Test touch interactions
- Request real device sensors (on iOS you'll need HTTPS)
- Closer to actual app experience

---

## Customization & Experimentation

### Change Sensor Simulation Speed
Edit `script.js`, line 148:
```javascript
sensorInterval = setInterval(() => {
    updateSensors(false);
}, 100); // Change this value (milliseconds)
```

### Modify "Falling" Physics
Edit `script.js`, lines 165-230 - adjust the `isIntense` behavior:
```javascript
const speed = isIntense ? 
    Math.abs(Math.sin(time * 1.5) * 55) : // Max speed when "falling"
    Math.abs(Math.sin(time * 0.3) * 5);
```

### Change Colors/Styling
Edit `styles.css` - all styles are clearly commented

### Add More Charities
Edit `index.html` starting at line 57 - copy/paste charity-item divs

---

## Technical Details

### Technologies Used
- **Pure HTML/CSS/JavaScript** - No frameworks required
- **LocalStorage API** - For persistent state
- **MediaDevices API** - For camera access (if available)
- **Device Motion/Orientation APIs** - For real sensor data (if available)
- **Responsive CSS** - Works on all screen sizes

### File Structure
```
web-demo/
├── index.html          # Main HTML structure
├── styles.css          # All styling and animations
├── script.js           # App logic and sensor simulation
└── README_DEMO.md      # This file
```

### Browser Compatibility
- ✅ Chrome/Edge (all features)
- ✅ Firefox (all features)
- ✅ Safari (all features)
- ✅ Mobile Safari (all features, real sensors with HTTPS)
- ✅ Mobile Chrome (all features)

---

## Demonstrating to Others

### For Quick Demo
1. Start server: `python3 -m http.server 8000`
2. Open: http://localhost:8000
3. Walk through the charity prompt
4. Show the sensor overlay
5. Tap record to show "intense" sensor data
6. Open settings to show platform list

### For Screenshots/Video
1. Use browser DevTools device emulation (F12 → Device Toolbar)
2. Select iPhone 14 Pro or similar
3. Take screenshots at each screen
4. Record screen video while interacting

### For User Testing
1. Share your local IP on network
2. Have others access from their phones
3. Watch how they interact with charity prompt
4. Get feedback on UI/UX

---

## Comparing to Real iOS App

### What's the Same
✅ Charity prompt text and layout
✅ 8 charities with real donation links
✅ Acknowledgment requirement
✅ Sensor data types and formatting
✅ Main UI layout and controls
✅ Settings screen structure
✅ Overall user flow

### What's Different
❌ No real camera feed (simulated)
❌ No real sensor data (mathematically generated)
❌ No actual video recording
❌ No social media OAuth
❌ No RTMP streaming
❌ No native iOS UI elements (uses web equivalents)

### Why This Demo is Valuable
- ✅ See complete user experience without Xcode
- ✅ Test charity prompt messaging
- ✅ Verify sensor data display layout
- ✅ Check UI responsiveness
- ✅ Share with stakeholders easily
- ✅ Get early feedback before iOS development
- ✅ Use for marketing/press materials

---

## Next Steps

### To Build the Real iOS App
1. Follow `QUICK_START.md` in the main repo
2. Open Xcode and create new iOS project
3. Import all Swift files from `IllAdvisedApp/`
4. Configure permissions in Info.plist
5. Test on real iPhone device

### To Improve This Demo
1. Add video background instead of gradient
2. Implement service worker for offline functionality
3. Add more dramatic "destruction" animations
4. Create shareable demo link (deploy to GitHub Pages)
5. Add sound effects (optional)

---

## Deployment (Optional)

### Host on GitHub Pages
```bash
cd /Users/fletcher/code/illadvised
git add web-demo/
git commit -m "Add web demo"
git push

# Then enable GitHub Pages in repo settings
# Select branch: main
# Select folder: /web-demo
```

Your demo will be at: `https://[username].github.io/illadvised/`

### Host on Netlify
1. Drag `web-demo` folder to Netlify drop zone
2. Get instant public URL
3. Share with anyone

---

## Troubleshooting

### Camera Not Working
**Cause:** Browser needs HTTPS for camera access (except localhost)
**Fix:** Use localhost, or deploy with HTTPS, or ignore (placeholder will show)

### Sensor Data Not Updating
**Cause:** JavaScript not running
**Fix:** Check browser console (F12) for errors

### Charity Prompt Not Showing Again
**Cause:** LocalStorage remembers you've seen it
**Fix:** Click "Reset Charity Prompt" in Settings, or clear localStorage

### Can't Access from Phone
**Cause:** Firewall blocking port 8000
**Fix:** 
```bash
# On Mac, temporarily allow:
sudo pfctl -d  # Disable firewall
# Or add rule for port 8000
```

---

## Demo URL Structure

```
/                          → Charity prompt (first visit) or Main screen
/index.html                → Same as /
/?reset=true               → Force show charity prompt
```

---

## Keyboard Shortcuts (Desktop)

- **Space** - Toggle recording
- **S** - Open settings
- **Esc** - Close settings
- **C** - Switch camera
- **R** - Reset charity prompt

(Not implemented yet, but easy to add if desired)

---

## Performance Notes

- Sensor updates: 100ms normally, 50ms when recording
- Minimal CPU usage when not recording
- No memory leaks (cleanup on unload)
- Works smoothly on low-end devices

---

## Questions & Ideas

### Can I add more charities?
Yes! Just copy a charity-item div in index.html and update the info.

### Can I change the sensor refresh rate?
Yes! Edit the setInterval values in script.js.

### Can I make this a Progressive Web App?
Yes! Add a manifest.json and service worker.

### Can I use real sensor data?
On mobile with HTTPS, the demo will request real device sensors if you modify the code to enable it.

---

## Summary

This web demo provides a **complete preview** of the Ill Advised app experience:
- ✅ Charity social consciousness component
- ✅ Main recording interface with sensor overlay
- ✅ Settings and platform management
- ✅ Simulated "destruction" physics
- ✅ Mobile-responsive design

**Perfect for:**
- Quick demonstrations
- User testing
- Stakeholder review
- Press materials
- Understanding the concept before iOS development

**Start it now:**
```bash
cd /Users/fletcher/code/illadvised/web-demo && python3 -m http.server 8000
```
Then open: **http://localhost:8000**
