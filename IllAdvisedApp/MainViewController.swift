import UIKit
import AVFoundation
import Combine

class MainViewController: UIViewController {
    private let cameraManager = CameraManager()
    private let locationManager = LocationManager()
    private let motionManager = MotionManager()
    private let recordingManager = VideoRecordingManager()
    private var streamingManager: StreamingManager?
    
    private var cancellables = Set<AnyCancellable>()
    
    // Top third - Back camera view
    private let backCameraView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        return view
    }()
    
    private let backCameraLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "BACK CAMERA"
        label.font = UIFont.systemFont(ofSize: 10, weight: .semibold)
        label.textColor = UIColor.white.withAlphaComponent(0.6)
        return label
    }()
    
    // Middle third - Sensor data + app name
    private let sensorContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        return view
    }()
    
    private let sensorOverlayView = SensorOverlayView()
    
    private let appNameWarningLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "ill Advised"
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.layer.borderWidth = 0
        label.layer.borderColor = UIColor.red.cgColor
        label.layer.cornerRadius = 8
        label.clipsToBounds = true
        return label
    }()
    
    // Bottom third - Front camera view
    private let frontCameraView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        return view
    }()
    
    private let frontCameraLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "FRONT CAMERA"
        label.font = UIFont.systemFont(ofSize: 10, weight: .semibold)
        label.textColor = UIColor.white.withAlphaComponent(0.6)
        return label
    }()
    
    // Divider lines
    private func createDividerLine() -> UIView {
        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = .yellow
        return line
    }
    
    private let recordButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .red
        button.layer.cornerRadius = 40
        button.setTitle("", for: .normal)
        return button
    }()
    
    private let switchCameraButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "camera.rotate"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        button.layer.cornerRadius = 25
        return button
    }()
    
    private let settingsButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "gearshape"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        button.layer.cornerRadius = 25
        return button
    }()
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .center
        label.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        label.layer.cornerRadius = 8
        label.clipsToBounds = true
        label.text = "Ready"
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        setupUI()
        setupBindings()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if FeatureFlags.enableIntroAnimation && !UserDefaults.standard.bool(forKey: "HasSeenIntro") {
            showIntroAnimation()
        } else if FeatureFlags.enableCharityPrompt && !UserDefaults.standard.bool(forKey: "HasSeenCharityPrompt") {
            showCharityPrompt()
        } else {
            requestPermissions()
        }
    }
    
    private func showIntroAnimation() {
        let introVC = IntroAnimationViewController()
        introVC.modalPresentationStyle = .fullScreen
        introVC.onComplete = { [weak self] in
            UserDefaults.standard.set(true, forKey: "HasSeenIntro")
            self?.dismiss(animated: false) {
                if !UserDefaults.standard.bool(forKey: "HasSeenCharityPrompt") {
                    self?.showCharityPrompt()
                } else {
                    self?.requestPermissions()
                }
            }
        }
        present(introVC, animated: false)
    }
    
    private func showCharityPrompt() {
        let charityVC = CharityPromptViewController()
        charityVC.modalPresentationStyle = .fullScreen
        charityVC.onContinue = { [weak self] in
            self?.requestPermissions()
        }
        present(charityVC, animated: true)
    }
    
    private func setupUI() {
        // Add three main sections
        view.addSubview(backCameraView)
        view.addSubview(sensorContainerView)
        view.addSubview(frontCameraView)
        
        // Add divider lines
        let topDivider = createDividerLine()
        let bottomDivider = createDividerLine()
        view.addSubview(topDivider)
        view.addSubview(bottomDivider)
        
        // Add labels to camera views
        backCameraView.addSubview(backCameraLabel)
        frontCameraView.addSubview(frontCameraLabel)
        
        // Add sensor overlay and app name warning to middle section
        sensorOverlayView.translatesAutoresizingMaskIntoConstraints = false
        sensorContainerView.addSubview(sensorOverlayView)
        sensorContainerView.addSubview(appNameWarningLabel)
        
        // Add control buttons
        view.addSubview(recordButton)
        view.addSubview(switchCameraButton)
        view.addSubview(settingsButton)
        
        // Layout - Three equal sections
        NSLayoutConstraint.activate([
            // Back camera - top third
            backCameraView.topAnchor.constraint(equalTo: view.topAnchor),
            backCameraView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backCameraView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backCameraView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.33333),
            
            backCameraLabel.topAnchor.constraint(equalTo: backCameraView.safeAreaLayoutGuide.topAnchor, constant: 10),
            backCameraLabel.leadingAnchor.constraint(equalTo: backCameraView.leadingAnchor, constant: 10),
            
            // Top divider
            topDivider.topAnchor.constraint(equalTo: backCameraView.bottomAnchor),
            topDivider.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topDivider.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topDivider.heightAnchor.constraint(equalToConstant: 2),
            
            // Sensor container - middle third
            sensorContainerView.topAnchor.constraint(equalTo: topDivider.bottomAnchor),
            sensorContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sensorContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            sensorContainerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.33333),
            
            // Sensor overlay at top of middle section
            sensorOverlayView.topAnchor.constraint(equalTo: sensorContainerView.topAnchor, constant: 12),
            sensorOverlayView.leadingAnchor.constraint(equalTo: sensorContainerView.leadingAnchor, constant: 12),
            sensorOverlayView.trailingAnchor.constraint(equalTo: sensorContainerView.trailingAnchor, constant: -12),
            
            // App name warning at bottom of middle section
            appNameWarningLabel.topAnchor.constraint(greaterThanOrEqualTo: sensorOverlayView.bottomAnchor, constant: 8),
            appNameWarningLabel.leadingAnchor.constraint(equalTo: sensorContainerView.leadingAnchor, constant: 20),
            appNameWarningLabel.trailingAnchor.constraint(equalTo: sensorContainerView.trailingAnchor, constant: -20),
            appNameWarningLabel.bottomAnchor.constraint(equalTo: sensorContainerView.bottomAnchor, constant: -12),
            appNameWarningLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 50),
            
            // Bottom divider
            bottomDivider.topAnchor.constraint(equalTo: sensorContainerView.bottomAnchor),
            bottomDivider.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomDivider.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomDivider.heightAnchor.constraint(equalToConstant: 2),
            
            // Front camera - bottom third
            frontCameraView.topAnchor.constraint(equalTo: bottomDivider.bottomAnchor),
            frontCameraView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            frontCameraView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            frontCameraView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            frontCameraLabel.topAnchor.constraint(equalTo: frontCameraView.topAnchor, constant: 10),
            frontCameraLabel.leadingAnchor.constraint(equalTo: frontCameraView.leadingAnchor, constant: 10),
            
            // Control buttons - floating over bottom section
            recordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            recordButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            recordButton.widthAnchor.constraint(equalToConstant: 70),
            recordButton.heightAnchor.constraint(equalToConstant: 70),
            
            switchCameraButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            switchCameraButton.centerYAnchor.constraint(equalTo: recordButton.centerYAnchor),
            switchCameraButton.widthAnchor.constraint(equalToConstant: 50),
            switchCameraButton.heightAnchor.constraint(equalToConstant: 50),
            
            settingsButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            settingsButton.centerYAnchor.constraint(equalTo: recordButton.centerYAnchor),
            settingsButton.widthAnchor.constraint(equalToConstant: 50),
            settingsButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        recordButton.addTarget(self, action: #selector(recordButtonTapped), for: .touchUpInside)
        switchCameraButton.addTarget(self, action: #selector(switchCameraTapped), for: .touchUpInside)
        settingsButton.addTarget(self, action: #selector(settingsButtonTapped), for: .touchUpInside)
    }
    
    private func setupBindings() {
        sensorOverlayView.bindToManagers(locationManager: locationManager, motionManager: motionManager)
        
        recordingManager.$isRecording
            .sink { [weak self] isRecording in
                self?.updateRecordButton(isRecording: isRecording)
                self?.statusLabel.text = isRecording ? "Recording" : "Ready"
            }
            .store(in: &cancellables)
        
        // Only setup streaming if feature is enabled
        if FeatureFlags.enableSocialMediaStreaming {
            streamingManager = StreamingManager()
            streamingManager?.$isStreaming
                .sink { [weak self] isStreaming in
                    if isStreaming {
                        self?.statusLabel.text = "Streaming"
                    }
                }
                .store(in: &cancellables)
        }
    }
    
    private func requestPermissions() {
        locationManager.requestAuthorization()
        
        cameraManager.requestAuthorization { [weak self] granted in
            if granted {
                self?.setupCamera()
            } else {
                self?.showPermissionAlert()
            }
        }
    }
    
    private func setupCamera() {
        do {
            try cameraManager.setupSession(useMultiCam: cameraManager.isMultiCamSupported)
            
            // For now, we'll show the back camera in the top section
            // In a full implementation, you'd configure separate preview layers for each camera
            if let previewLayer = cameraManager.createPreviewLayer() {
                previewLayer.frame = backCameraView.bounds
                backCameraView.layer.insertSublayer(previewLayer, at: 0)
                
                // If multi-cam is supported, you could add a second preview layer to frontCameraView
                // For this demo, we'll just show placeholders
            }
            
            cameraManager.startSession()
            
            locationManager.startUpdating()
            motionManager.startUpdating()
        } catch {
            showErrorAlert(message: "Failed to setup camera: \(error.localizedDescription)")
        }
    }
    
    @objc private func recordButtonTapped() {
        if recordingManager.isRecording {
            stopRecording()
        } else {
            startRecording()
        }
    }
    
    private func startRecording() {
        do {
            let size = view.bounds.size
            try recordingManager.startRecording(size: size)
            startBlinkingWarning()
        } catch {
            showErrorAlert(message: "Failed to start recording: \(error.localizedDescription)")
        }
    }
    
    private func startBlinkingWarning() {
        appNameWarningLabel.layer.borderWidth = 3
        
        UIView.animate(withDuration: 0.5, delay: 0, options: [.repeat, .autoreverse, .allowUserInteraction]) {
            self.appNameWarningLabel.backgroundColor = UIColor.red.withAlphaComponent(0.1)
        }
    }
    
    private func stopBlinkingWarning() {
        appNameWarningLabel.layer.removeAllAnimations()
        appNameWarningLabel.layer.borderWidth = 0
        appNameWarningLabel.backgroundColor = .clear
    }
    
    private func stopRecording() {
        stopBlinkingWarning()
        recordingManager.stopRecording { [weak self] url, error in
            if let error = error {
                self?.showErrorAlert(message: "Recording failed: \(error.localizedDescription)")
            } else if let url = url {
                self?.showSuccessAlert(message: "Video saved to: \(url.lastPathComponent)")
            }
        }
    }
    
    @objc private func switchCameraTapped() {
        do {
            try cameraManager.switchCamera()
        } catch {
            showErrorAlert(message: "Failed to switch camera: \(error.localizedDescription)")
        }
    }
    
    @objc private func settingsButtonTapped() {
        let settingsVC = SettingsViewController()
        let navController = UINavigationController(rootViewController: settingsVC)
        present(navController, animated: true)
    }
    
    private func updateRecordButton(isRecording: Bool) {
        UIView.animate(withDuration: 0.3) {
            self.recordButton.backgroundColor = isRecording ? .systemGray : .red
            self.recordButton.transform = isRecording ? CGAffineTransform(scaleX: 0.7, y: 0.7) : .identity
        }
    }
    
    private func showPermissionAlert() {
        let alert = UIAlertController(
            title: "Permissions Required",
            message: "This app requires camera, microphone, and location permissions to function.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Settings", style: .default) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func showSuccessAlert(message: String) {
        let alert = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        cameraManager.previewLayer?.frame = backCameraView.bounds
    }
}
