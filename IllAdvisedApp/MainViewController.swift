import UIKit
import AVFoundation
import Combine

class MainViewController: UIViewController {
    private let cameraManager = CameraManager()
    private let locationManager = LocationManager()
    private let motionManager = MotionManager()
    private let recordingManager = VideoRecordingManager()
    private let streamingManager = StreamingManager()
    
    private var cancellables = Set<AnyCancellable>()
    
    private let previewContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        return view
    }()
    
    private let sensorOverlayView = SensorOverlayView()
    
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
        
        if !UserDefaults.standard.bool(forKey: "HasSeenCharityPrompt") {
            showCharityPrompt()
        } else {
            requestPermissions()
        }
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
        view.addSubview(previewContainerView)
        
        sensorOverlayView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sensorOverlayView)
        
        view.addSubview(recordButton)
        view.addSubview(switchCameraButton)
        view.addSubview(settingsButton)
        view.addSubview(statusLabel)
        
        NSLayoutConstraint.activate([
            previewContainerView.topAnchor.constraint(equalTo: view.topAnchor),
            previewContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            previewContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            previewContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            sensorOverlayView.topAnchor.constraint(equalTo: view.topAnchor),
            sensorOverlayView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sensorOverlayView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            sensorOverlayView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            recordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            recordButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            recordButton.widthAnchor.constraint(equalToConstant: 80),
            recordButton.heightAnchor.constraint(equalToConstant: 80),
            
            switchCameraButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            switchCameraButton.centerYAnchor.constraint(equalTo: recordButton.centerYAnchor),
            switchCameraButton.widthAnchor.constraint(equalToConstant: 50),
            switchCameraButton.heightAnchor.constraint(equalToConstant: 50),
            
            settingsButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            settingsButton.centerYAnchor.constraint(equalTo: recordButton.centerYAnchor),
            settingsButton.widthAnchor.constraint(equalToConstant: 50),
            settingsButton.heightAnchor.constraint(equalToConstant: 50),
            
            statusLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            statusLabel.bottomAnchor.constraint(equalTo: recordButton.topAnchor, constant: -20),
            statusLabel.widthAnchor.constraint(equalToConstant: 200),
            statusLabel.heightAnchor.constraint(equalToConstant: 30)
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
        
        streamingManager.$isStreaming
            .sink { [weak self] isStreaming in
                if isStreaming {
                    self?.statusLabel.text = "Streaming"
                }
            }
            .store(in: &cancellables)
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
            
            if let previewLayer = cameraManager.createPreviewLayer() {
                previewLayer.frame = previewContainerView.bounds
                previewContainerView.layer.insertSublayer(previewLayer, at: 0)
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
            let size = previewContainerView.bounds.size
            try recordingManager.startRecording(size: size)
        } catch {
            showErrorAlert(message: "Failed to start recording: \(error.localizedDescription)")
        }
    }
    
    private func stopRecording() {
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
        cameraManager.previewLayer?.frame = previewContainerView.bounds
    }
}
