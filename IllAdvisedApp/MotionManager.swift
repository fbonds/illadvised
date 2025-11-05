import CoreMotion
import Combine

class MotionManager: ObservableObject {
    private let motionManager = CMMotionManager()
    private let altimeter = CMAltimeter()
    private let pedometer = CMPedometer()
    
    @Published var roll: Double = 0.0
    @Published var pitch: Double = 0.0
    @Published var yaw: Double = 0.0
    
    @Published var accelerationX: Double = 0.0
    @Published var accelerationY: Double = 0.0
    @Published var accelerationZ: Double = 0.0
    
    @Published var rotationRateX: Double = 0.0
    @Published var rotationRateY: Double = 0.0
    @Published var rotationRateZ: Double = 0.0
    
    @Published var magneticFieldX: Double = 0.0
    @Published var magneticFieldY: Double = 0.0
    @Published var magneticFieldZ: Double = 0.0
    
    @Published var pressure: Double = 0.0
    @Published var relativeAltitude: Double = 0.0
    
    @Published var stepCount: Int = 0
    
    private var updateQueue = OperationQueue()
    
    init() {
        updateQueue.maxConcurrentOperationCount = 1
        updateQueue.qualityOfService = .userInteractive
    }
    
    func startUpdating() {
        startDeviceMotionUpdates()
        startAltimeterUpdates()
        startPedometerUpdates()
    }
    
    func stopUpdating() {
        motionManager.stopDeviceMotionUpdates()
        altimeter.stopRelativeAltitudeUpdates()
        pedometer.stopUpdates()
    }
    
    private func startDeviceMotionUpdates() {
        guard motionManager.isDeviceMotionAvailable else {
            print("Device motion not available")
            return
        }
        
        motionManager.deviceMotionUpdateInterval = 0.1
        motionManager.startDeviceMotionUpdates(using: .xMagneticNorthZVertical, to: updateQueue) { [weak self] motion, error in
            guard let motion = motion, error == nil else {
                if let error = error {
                    print("Device motion error: \(error.localizedDescription)")
                }
                return
            }
            
            DispatchQueue.main.async {
                self?.roll = motion.attitude.roll * 180 / .pi
                self?.pitch = motion.attitude.pitch * 180 / .pi
                self?.yaw = motion.attitude.yaw * 180 / .pi
                
                self?.accelerationX = motion.userAcceleration.x
                self?.accelerationY = motion.userAcceleration.y
                self?.accelerationZ = motion.userAcceleration.z
                
                self?.rotationRateX = motion.rotationRate.x * 180 / .pi
                self?.rotationRateY = motion.rotationRate.y * 180 / .pi
                self?.rotationRateZ = motion.rotationRate.z * 180 / .pi
                
                self?.magneticFieldX = motion.magneticField.field.x
                self?.magneticFieldY = motion.magneticField.field.y
                self?.magneticFieldZ = motion.magneticField.field.z
            }
        }
    }
    
    private func startAltimeterUpdates() {
        guard CMAltimeter.isRelativeAltitudeAvailable() else {
            print("Relative altitude not available")
            return
        }
        
        altimeter.startRelativeAltitudeUpdates(to: updateQueue) { [weak self] data, error in
            guard let data = data, error == nil else {
                if let error = error {
                    print("Altimeter error: \(error.localizedDescription)")
                }
                return
            }
            
            DispatchQueue.main.async {
                self?.relativeAltitude = data.relativeAltitude.doubleValue
                self?.pressure = data.pressure.doubleValue
            }
        }
    }
    
    private func startPedometerUpdates() {
        guard CMPedometer.isStepCountingAvailable() else {
            print("Step counting not available")
            return
        }
        
        pedometer.startUpdates(from: Date()) { [weak self] data, error in
            guard let data = data, error == nil else {
                if let error = error {
                    print("Pedometer error: \(error.localizedDescription)")
                }
                return
            }
            
            DispatchQueue.main.async {
                self?.stepCount = data.numberOfSteps.intValue
            }
        }
    }
}
