// Screen management
const screens = {
    intro: document.getElementById('introScreen'),
    charity: document.getElementById('charityScreen'),
    main: document.getElementById('mainScreen'),
    settings: document.getElementById('settingsScreen')
};

let currentScreen = 'intro';
let isRecording = false;
let sensorInterval = null;
let cameraStream = null;

// Check if user has seen charity prompt
function hasSeenCharityPrompt() {
    return localStorage.getItem('hasSeenCharityPrompt') === 'true';
}

function setCharityPromptSeen() {
    localStorage.setItem('hasSeenCharityPrompt', 'true');
}

function resetCharityPrompt() {
    localStorage.removeItem('hasSeenCharityPrompt');
    location.reload();
}

// Show specific screen
function showScreen(screenName) {
    Object.values(screens).forEach(screen => screen.classList.remove('active'));
    screens[screenName].classList.add('active');
    currentScreen = screenName;
}

// Initialize app
function init() {
    // Always show intro animation first
    showScreen('intro');
    playIntroAnimation();
    
    setupEventListeners();
}

// Play intro animation
function playIntroAnimation() {
    const explosion = document.getElementById('explosion');
    
    // Trigger explosion at the right moment
    setTimeout(() => {
        explosion.classList.add('active');
    }, 2300);
    
    // After animation completes, show appropriate screen
    setTimeout(() => {
        if (hasSeenCharityPrompt()) {
            showScreen('main');
            initCamera();
            startSensorUpdates();
        } else {
            showScreen('charity');
        }
    }, 3500); // Total animation time
}

// Event listeners
function setupEventListeners() {
    // Charity prompt
    const checkbox = document.getElementById('acknowledgeCheckbox');
    const continueBtn = document.getElementById('continueBtn');
    
    checkbox.addEventListener('change', (e) => {
        continueBtn.disabled = !e.target.checked;
    });
    
    continueBtn.addEventListener('click', () => {
        setCharityPromptSeen();
        showScreen('main');
        initCamera();
        startSensorUpdates();
    });
    
    // Main screen controls
    document.getElementById('recordBtn').addEventListener('click', toggleRecording);
    document.getElementById('switchCameraBtn').addEventListener('click', switchCamera);
    document.getElementById('settingsBtn').addEventListener('click', () => showScreen('settings'));
    
    // Settings screen
    document.getElementById('closeSettings').addEventListener('click', () => showScreen('main'));
    document.getElementById('resetCharityPrompt').addEventListener('click', resetCharityPrompt);
}

// Camera initialization
async function initCamera() {
    try {
        const stream = await navigator.mediaDevices.getUserMedia({
            video: { facingMode: 'environment' },
            audio: true
        });
        
        cameraStream = stream;
        const backVideo = document.getElementById('backCameraFeed');
        const frontVideo = document.getElementById('frontCameraFeed');
        
        // In a real app, you'd get separate streams for front/back
        // For demo, we'll use the same stream or show placeholders
        backVideo.srcObject = stream;
        frontVideo.srcObject = stream;
    } catch (error) {
        console.error('Camera access denied:', error);
        showCameraPlaceholder();
    }
}

function showCameraPlaceholder() {
    const backCamera = document.querySelector('.back-camera');
    const frontCamera = document.querySelector('.front-camera');
    
    // Back camera already has gradient, add icon
    const backPlaceholder = document.createElement('div');
    backPlaceholder.style.cssText = `
        position: absolute;
        top: 50%;
        left: 50%;
        transform: translate(-50%, -50%);
        text-align: center;
        color: rgba(255, 255, 255, 0.8);
    `;
    backPlaceholder.innerHTML = `
        <div style="font-size: 48px; margin-bottom: 8px;">📹</div>
        <div style="font-size: 12px; font-weight: 600;">BACK CAMERA FEED</div>
        <div style="font-size: 10px; margin-top: 4px; color: rgba(255,255,255,0.6);">(Simulated)</div>
    `;
    backCamera.appendChild(backPlaceholder);
    
    // Front camera placeholder
    const frontPlaceholder = document.createElement('div');
    frontPlaceholder.style.cssText = `
        position: absolute;
        top: 50%;
        left: 50%;
        transform: translate(-50%, -50%);
        text-align: center;
        color: rgba(255, 255, 255, 0.8);
    `;
    frontPlaceholder.innerHTML = `
        <div style="font-size: 48px; margin-bottom: 8px;">🤳</div>
        <div style="font-size: 12px; font-weight: 600;">FRONT CAMERA FEED</div>
        <div style="font-size: 10px; margin-top: 4px; color: rgba(255,255,255,0.6);">(Simulated)</div>
    `;
    frontCamera.appendChild(frontPlaceholder);
}

function switchCamera() {
    // In real app, this would swap front/back camera streams
    const backCamera = document.querySelector('.back-camera');
    const frontCamera = document.querySelector('.front-camera');
    
    // Visual effect: swap the gradient colors
    const backBg = backCamera.style.background;
    const frontBg = frontCamera.style.background;
    
    backCamera.style.background = frontBg || 'linear-gradient(135deg, #f093fb 0%, #f5576c 100%)';
    frontCamera.style.background = backBg || 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)';
    
    // Add visual feedback to button
    const switchBtn = document.getElementById('switchCameraBtn');
    switchBtn.style.transform = 'rotate(180deg)';
    setTimeout(() => {
        switchBtn.style.transform = 'rotate(0deg)';
    }, 300);
}

// Recording toggle
function toggleRecording() {
    isRecording = !isRecording;
    const recordBtn = document.getElementById('recordBtn');
    const appNameWarning = document.getElementById('appNameWarning');
    
    if (isRecording) {
        recordBtn.classList.add('recording');
        appNameWarning.classList.add('recording');
        startIntenseSensorUpdates();
    } else {
        recordBtn.classList.remove('recording');
        appNameWarning.classList.remove('recording');
        startSensorUpdates();
    }
}

// Sensor data simulation
function startSensorUpdates() {
    if (sensorInterval) clearInterval(sensorInterval);
    
    sensorInterval = setInterval(() => {
        updateSensors(false);
    }, 100); // Update every 100ms
}

function startIntenseSensorUpdates() {
    if (sensorInterval) clearInterval(sensorInterval);
    
    sensorInterval = setInterval(() => {
        updateSensors(true);
    }, 50); // Update every 50ms when recording
}

function updateSensors(isIntense) {
    const time = Date.now() / 1000;
    
    // Simulate GPS coordinates changing slightly
    const baseLat = 37.7749;
    const baseLon = -122.4194;
    const latOffset = Math.sin(time * 0.1) * 0.001;
    const lonOffset = Math.cos(time * 0.1) * 0.001;
    document.getElementById('gps').textContent = 
        `${(baseLat + latOffset).toFixed(6)}°, ${(baseLon + lonOffset).toFixed(6)}°`;
    
    // Simulate altitude changes
    const baseAlt = 142.3;
    const altVariation = isIntense ? Math.sin(time * 2) * 50 : Math.sin(time * 0.5) * 2;
    const relAlt = isIntense ? Math.sin(time * 1.5) * 30 : 0;
    document.getElementById('altitude').textContent = 
        `${(baseAlt + altVariation).toFixed(1)}m (GPS) | ${relAlt.toFixed(1)}m (Rel)`;
    
    // Simulate speed
    const speed = isIntense ? 
        Math.abs(Math.sin(time * 1.5) * 55) : // Up to 55 MPH when "falling"
        Math.abs(Math.sin(time * 0.3) * 5);    // Walking speed otherwise
    document.getElementById('speed').textContent = `${speed.toFixed(1)} MPH`;
    
    // Simulate heading
    const heading = ((time * 30) % 360);
    const directions = ['N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW'];
    const dirIndex = Math.floor((heading + 22.5) / 45) % 8;
    document.getElementById('heading').textContent = 
        `${heading.toFixed(1)}° ${directions[dirIndex]}`;
    
    // Simulate orientation (roll, pitch, yaw)
    const roll = isIntense ? Math.sin(time * 3) * 180 : Math.sin(time * 0.5) * 30;
    const pitch = isIntense ? Math.cos(time * 2.5) * 90 : Math.cos(time * 0.3) * 15;
    const yaw = isIntense ? Math.sin(time * 2) * 180 : Math.sin(time * 0.4) * 45;
    document.getElementById('orientation').textContent = 
        `R:${roll.toFixed(1)}° P:${pitch.toFixed(1)}° Y:${yaw.toFixed(1)}°`;
    
    // Simulate acceleration
    const accelX = isIntense ? Math.sin(time * 4) * 3 : Math.sin(time) * 0.1;
    const accelY = isIntense ? Math.cos(time * 3.5) * 3 : Math.cos(time * 0.8) * 0.1;
    const accelZ = isIntense ? Math.sin(time * 3) * 5 : 1.0; // Gravity = 1g normally
    document.getElementById('accel').textContent = 
        `X:${accelX.toFixed(2)} Y:${accelY.toFixed(2)} Z:${accelZ.toFixed(2)} g`;
    
    // Simulate rotation rate
    const rotX = isIntense ? Math.sin(time * 5) * 360 : Math.sin(time * 0.5) * 10;
    const rotY = isIntense ? Math.cos(time * 4.5) * 360 : Math.cos(time * 0.6) * 10;
    const rotZ = isIntense ? Math.sin(time * 4) * 360 : Math.sin(time * 0.4) * 10;
    document.getElementById('rotation').textContent = 
        `X:${rotX.toFixed(1)} Y:${rotY.toFixed(1)} Z:${rotZ.toFixed(1)} °/s`;
    
    // Simulate pressure (varies with altitude)
    const pressure = 101.325 - (altVariation * 0.012); // Approx pressure change with altitude
    document.getElementById('pressure').textContent = `${pressure.toFixed(2)} kPa`;
    
    // Simulate steps (only when not "falling")
    const currentSteps = parseInt(document.getElementById('steps').textContent) || 0;
    if (!isIntense && Math.random() > 0.95) {
        document.getElementById('steps').textContent = currentSteps + 1;
    }
}

// Request device orientation/motion if available
function requestSensorAccess() {
    if (typeof DeviceMotionEvent !== 'undefined' && typeof DeviceMotionEvent.requestPermission === 'function') {
        DeviceMotionEvent.requestPermission()
            .then(permissionState => {
                if (permissionState === 'granted') {
                    window.addEventListener('devicemotion', handleDeviceMotion);
                }
            })
            .catch(console.error);
    }
    
    if (typeof DeviceOrientationEvent !== 'undefined' && typeof DeviceOrientationEvent.requestPermission === 'function') {
        DeviceOrientationEvent.requestPermission()
            .then(permissionState => {
                if (permissionState === 'granted') {
                    window.addEventListener('deviceorientation', handleDeviceOrientation);
                }
            })
            .catch(console.error);
    }
}

function handleDeviceMotion(event) {
    // Update with real sensor data if available
    if (event.acceleration) {
        const accel = event.acceleration;
        document.getElementById('accel').textContent = 
            `X:${(accel.x || 0).toFixed(2)} Y:${(accel.y || 0).toFixed(2)} Z:${(accel.z || 0).toFixed(2)} g`;
    }
    
    if (event.rotationRate) {
        const rot = event.rotationRate;
        document.getElementById('rotation').textContent = 
            `X:${(rot.alpha || 0).toFixed(1)} Y:${(rot.beta || 0).toFixed(1)} Z:${(rot.gamma || 0).toFixed(1)} °/s`;
    }
}

function handleDeviceOrientation(event) {
    // Update with real orientation data if available
    if (event.alpha !== null && event.beta !== null && event.gamma !== null) {
        document.getElementById('orientation').textContent = 
            `R:${event.gamma.toFixed(1)}° P:${event.beta.toFixed(1)}° Y:${event.alpha.toFixed(1)}°`;
    }
}

// Initialize on load
window.addEventListener('load', init);

// Cleanup on unload
window.addEventListener('beforeunload', () => {
    if (sensorInterval) clearInterval(sensorInterval);
    if (cameraStream) {
        cameraStream.getTracks().forEach(track => track.stop());
    }
});
