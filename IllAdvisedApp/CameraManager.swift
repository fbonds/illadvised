import AVFoundation
import UIKit
import Combine

class CameraManager: NSObject, ObservableObject {
    private var captureSession: AVCaptureSession?
    private var multiCamSession: AVCaptureMultiCamSession?
    private var frontCamera: AVCaptureDevice?
    private var backCamera: AVCaptureDevice?
    private var frontInput: AVCaptureDeviceInput?
    private var backInput: AVCaptureDeviceInput?
    private var audioInput: AVCaptureDeviceInput?
    private var videoOutput: AVCaptureVideoDataOutput?
    private var audioOutput: AVCaptureAudioDataOutput?
    
    @Published var isMultiCamSupported = false
    @Published var isRecording = false
    @Published var authorizationStatus: AVAuthorizationStatus = .notDetermined
    
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    private let videoQueue = DispatchQueue(label: "com.illadvised.videoQueue", qos: .userInteractive)
    private let audioQueue = DispatchQueue(label: "com.illadvised.audioQueue", qos: .userInteractive)
    
    override init() {
        super.init()
        checkMultiCamSupport()
    }
    
    private func checkMultiCamSupport() {
        isMultiCamSupported = AVCaptureMultiCamSession.isMultiCamSupported
    }
    
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        let cameraStatus = AVCaptureDevice.authorizationStatus(for: .video)
        let micStatus = AVCaptureDevice.authorizationStatus(for: .audio)
        
        if cameraStatus == .authorized && micStatus == .authorized {
            completion(true)
            return
        }
        
        AVCaptureDevice.requestAccess(for: .video) { videoGranted in
            AVCaptureDevice.requestAccess(for: .audio) { audioGranted in
                DispatchQueue.main.async {
                    self.authorizationStatus = videoGranted ? .authorized : .denied
                    completion(videoGranted && audioGranted)
                }
            }
        }
    }
    
    func setupSession(useMultiCam: Bool = false) throws {
        if useMultiCam && isMultiCamSupported {
            try setupMultiCamSession()
        } else {
            try setupSingleCamSession()
        }
    }
    
    private func setupSingleCamSession() throws {
        let session = AVCaptureSession()
        session.beginConfiguration()
        session.sessionPreset = .high
        
        guard let backCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
            throw CameraError.deviceNotFound
        }
        
        let videoInput = try AVCaptureDeviceInput(device: backCamera)
        if session.canAddInput(videoInput) {
            session.addInput(videoInput)
            self.backInput = videoInput
        }
        
        if let audioDevice = AVCaptureDevice.default(for: .audio) {
            let audioInput = try AVCaptureDeviceInput(device: audioDevice)
            if session.canAddInput(audioInput) {
                session.addInput(audioInput)
                self.audioInput = audioInput
            }
        }
        
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(self, queue: videoQueue)
        if session.canAddOutput(videoOutput) {
            session.addOutput(videoOutput)
            self.videoOutput = videoOutput
        }
        
        let audioOutput = AVCaptureAudioDataOutput()
        audioOutput.setSampleBufferDelegate(self, queue: audioQueue)
        if session.canAddOutput(audioOutput) {
            session.addOutput(audioOutput)
            self.audioOutput = audioOutput
        }
        
        session.commitConfiguration()
        self.captureSession = session
    }
    
    private func setupMultiCamSession() throws {
        let session = AVCaptureMultiCamSession()
        session.beginConfiguration()
        
        guard let backCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
              let frontCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {
            throw CameraError.deviceNotFound
        }
        
        let backInput = try AVCaptureDeviceInput(device: backCamera)
        let frontInput = try AVCaptureDeviceInput(device: frontCamera)
        
        if session.canAddInput(backInput) {
            session.addInput(backInput)
            self.backInput = backInput
        }
        
        if session.canAddInput(frontInput) {
            session.addInput(frontInput)
            self.frontInput = frontInput
        }
        
        if let audioDevice = AVCaptureDevice.default(for: .audio) {
            let audioInput = try AVCaptureDeviceInput(device: audioDevice)
            if session.canAddInput(audioInput) {
                session.addInput(audioInput)
                self.audioInput = audioInput
            }
        }
        
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(self, queue: videoQueue)
        if session.canAddOutput(videoOutput) {
            session.addOutput(videoOutput)
            self.videoOutput = videoOutput
        }
        
        let audioOutput = AVCaptureAudioDataOutput()
        audioOutput.setSampleBufferDelegate(self, queue: audioQueue)
        if session.canAddOutput(audioOutput) {
            session.addOutput(audioOutput)
            self.audioOutput = audioOutput
        }
        
        session.commitConfiguration()
        self.multiCamSession = session
        self.captureSession = session
    }
    
    func startSession() {
        videoQueue.async { [weak self] in
            self?.captureSession?.startRunning()
        }
    }
    
    func stopSession() {
        videoQueue.async { [weak self] in
            self?.captureSession?.stopRunning()
        }
    }
    
    func switchCamera() throws {
        guard let session = captureSession, !isMultiCamSupported else { return }
        
        session.beginConfiguration()
        
        if let currentInput = backInput {
            session.removeInput(currentInput)
            
            let newCamera = currentInput.device.position == .back ? 
                AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) :
                AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
            
            guard let camera = newCamera else {
                throw CameraError.deviceNotFound
            }
            
            let newInput = try AVCaptureDeviceInput(device: camera)
            if session.canAddInput(newInput) {
                session.addInput(newInput)
                self.backInput = newInput
            }
        }
        
        session.commitConfiguration()
    }
    
    func createPreviewLayer() -> AVCaptureVideoPreviewLayer? {
        guard let session = captureSession else { return nil }
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill
        self.previewLayer = previewLayer
        return previewLayer
    }
}

extension CameraManager: AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureAudioDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
    }
    
    func captureOutput(_ output: AVCaptureOutput, didDrop sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
    }
}

enum CameraError: Error {
    case deviceNotFound
    case inputCreationFailed
    case sessionConfigurationFailed
}
