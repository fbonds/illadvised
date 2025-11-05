import AVFoundation
import UIKit
import Combine

class VideoRecordingManager: NSObject, ObservableObject {
    private var assetWriter: AVAssetWriter?
    private var videoInput: AVAssetWriterInput?
    private var audioInput: AVAssetWriterInput?
    private var pixelBufferAdaptor: AVAssetWriterInputPixelBufferAdaptor?
    
    @Published var isRecording = false
    @Published var recordingURL: URL?
    
    private var startTime: CMTime?
    private let recordingQueue = DispatchQueue(label: "com.illadvised.recordingQueue", qos: .userInteractive)
    
    var locationManager: LocationManager?
    var motionManager: MotionManager?
    
    func startRecording(size: CGSize) throws {
        let outputURL = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
            .appendingPathExtension("mp4")
        
        assetWriter = try AVAssetWriter(outputURL: outputURL, fileType: .mp4)
        
        let videoSettings: [String: Any] = [
            AVVideoCodecKey: AVVideoCodecType.h264,
            AVVideoWidthKey: size.width,
            AVVideoHeightKey: size.height,
            AVVideoCompressionPropertiesKey: [
                AVVideoAverageBitRateKey: 6_000_000,
                AVVideoProfileLevelKey: AVVideoProfileLevelH264HighAutoLevel
            ]
        ]
        
        videoInput = AVAssetWriterInput(mediaType: .video, outputSettings: videoSettings)
        videoInput?.expectsMediaDataInRealTime = true
        
        let sourcePixelBufferAttributes: [String: Any] = [
            kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32ARGB,
            kCVPixelBufferWidthKey as String: size.width,
            kCVPixelBufferHeightKey as String: size.height
        ]
        
        pixelBufferAdaptor = AVAssetWriterInputPixelBufferAdaptor(
            assetWriterInput: videoInput!,
            sourcePixelBufferAttributes: sourcePixelBufferAttributes
        )
        
        let audioSettings: [String: Any] = [
            AVFormatIDKey: kAudioFormatMPEG4AAC,
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 2,
            AVEncoderBitRateKey: 128_000
        ]
        
        audioInput = AVAssetWriterInput(mediaType: .audio, outputSettings: audioSettings)
        audioInput?.expectsMediaDataInRealTime = true
        
        if let videoInput = videoInput, assetWriter?.canAdd(videoInput) == true {
            assetWriter?.add(videoInput)
        }
        
        if let audioInput = audioInput, assetWriter?.canAdd(audioInput) == true {
            assetWriter?.add(audioInput)
        }
        
        guard assetWriter?.startWriting() == true else {
            throw RecordingError.writerStartFailed
        }
        
        assetWriter?.startSession(atSourceTime: .zero)
        startTime = .zero
        
        DispatchQueue.main.async {
            self.isRecording = true
            self.recordingURL = outputURL
        }
    }
    
    func stopRecording(completion: @escaping (URL?, Error?) -> Void) {
        guard isRecording else {
            completion(nil, RecordingError.notRecording)
            return
        }
        
        videoInput?.markAsFinished()
        audioInput?.markAsFinished()
        
        let url = recordingURL
        
        assetWriter?.finishWriting { [weak self] in
            DispatchQueue.main.async {
                self?.isRecording = false
                
                if self?.assetWriter?.status == .completed {
                    completion(url, nil)
                } else {
                    completion(nil, self?.assetWriter?.error ?? RecordingError.writerFinishFailed)
                }
                
                self?.cleanup()
            }
        }
    }
    
    func appendVideoBuffer(_ sampleBuffer: CMSampleBuffer, withOverlay overlay: UIImage? = nil) {
        guard isRecording,
              let videoInput = videoInput,
              let pixelBufferAdaptor = pixelBufferAdaptor,
              videoInput.isReadyForMoreMediaData else {
            return
        }
        
        recordingQueue.async { [weak self] in
            guard let self = self else { return }
            
            let timestamp = CMSampleBufferGetPresentationTimeStamp(sampleBuffer)
            
            if let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) {
                var pixelBuffer = imageBuffer
                
                if let overlay = overlay {
                    pixelBuffer = self.addOverlay(overlay, to: imageBuffer) ?? imageBuffer
                }
                
                pixelBufferAdaptor.append(pixelBuffer, withPresentationTime: timestamp)
            }
        }
    }
    
    func appendAudioBuffer(_ sampleBuffer: CMSampleBuffer) {
        guard isRecording,
              let audioInput = audioInput,
              audioInput.isReadyForMoreMediaData else {
            return
        }
        
        recordingQueue.async {
            audioInput.append(sampleBuffer)
        }
    }
    
    private func addOverlay(_ overlay: UIImage, to pixelBuffer: CVPixelBuffer) -> CVPixelBuffer? {
        let width = CVPixelBufferGetWidth(pixelBuffer)
        let height = CVPixelBufferGetHeight(pixelBuffer)
        
        var newPixelBuffer: CVPixelBuffer?
        let options = [
            kCVPixelBufferCGImageCompatibilityKey as String: true,
            kCVPixelBufferCGBitmapContextCompatibilityKey as String: true
        ] as CFDictionary
        
        CVPixelBufferCreate(kCFAllocatorDefault, width, height, kCVPixelFormatType_32ARGB, options, &newPixelBuffer)
        
        guard let outputBuffer = newPixelBuffer else { return nil }
        
        CVPixelBufferLockBaseAddress(pixelBuffer, .readOnly)
        CVPixelBufferLockBaseAddress(outputBuffer, [])
        
        let context = CGContext(
            data: CVPixelBufferGetBaseAddress(outputBuffer),
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: CVPixelBufferGetBytesPerRow(outputBuffer),
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue
        )
        
        if let context = context, let cgImage = pixelBuffer.cgImage {
            context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
            
            if let overlayImage = overlay.cgImage {
                context.draw(overlayImage, in: CGRect(x: 0, y: 0, width: width, height: height))
            }
        }
        
        CVPixelBufferUnlockBaseAddress(outputBuffer, [])
        CVPixelBufferUnlockBaseAddress(pixelBuffer, .readOnly)
        
        return outputBuffer
    }
    
    private func cleanup() {
        assetWriter = nil
        videoInput = nil
        audioInput = nil
        pixelBufferAdaptor = nil
        startTime = nil
        recordingURL = nil
    }
}

extension CVPixelBuffer {
    var cgImage: CGImage? {
        CVPixelBufferLockBaseAddress(self, .readOnly)
        defer { CVPixelBufferUnlockBaseAddress(self, .readOnly) }
        
        let width = CVPixelBufferGetWidth(self)
        let height = CVPixelBufferGetHeight(self)
        let bytesPerRow = CVPixelBufferGetBytesPerRow(self)
        
        guard let baseAddress = CVPixelBufferGetBaseAddress(self) else { return nil }
        
        let context = CGContext(
            data: baseAddress,
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: bytesPerRow,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue
        )
        
        return context?.makeImage()
    }
}

enum RecordingError: Error {
    case writerStartFailed
    case writerFinishFailed
    case notRecording
}
