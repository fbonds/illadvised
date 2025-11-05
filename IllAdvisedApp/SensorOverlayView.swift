import UIKit
import Combine

class SensorOverlayView: UIView {
    private var cancellables = Set<AnyCancellable>()
    
    private let containerStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        stack.layer.cornerRadius = 8
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        return stack
    }()
    
    private let gpsLabel = createLabel()
    private let altitudeLabel = createLabel()
    private let speedLabel = createLabel()
    private let headingLabel = createLabel()
    private let orientationLabel = createLabel()
    private let accelerationLabel = createLabel()
    private let rotationLabel = createLabel()
    private let pressureLabel = createLabel()
    private let stepsLabel = createLabel()
    
    private static func createLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont.monospacedSystemFont(ofSize: 12, weight: .medium)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        addSubview(containerStack)
        
        containerStack.addArrangedSubview(gpsLabel)
        containerStack.addArrangedSubview(altitudeLabel)
        containerStack.addArrangedSubview(speedLabel)
        containerStack.addArrangedSubview(headingLabel)
        containerStack.addArrangedSubview(orientationLabel)
        containerStack.addArrangedSubview(accelerationLabel)
        containerStack.addArrangedSubview(rotationLabel)
        containerStack.addArrangedSubview(pressureLabel)
        containerStack.addArrangedSubview(stepsLabel)
        
        NSLayoutConstraint.activate([
            containerStack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            containerStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            containerStack.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -16)
        ])
    }
    
    func bindToManagers(locationManager: LocationManager, motionManager: MotionManager) {
        locationManager.$latitude
            .combineLatest(locationManager.$longitude)
            .sink { [weak self] lat, lon in
                self?.gpsLabel.text = String(format: "GPS: %.6f°, %.6f°", lat, lon)
            }
            .store(in: &cancellables)
        
        locationManager.$altitude
            .combineLatest(motionManager.$relativeAltitude)
            .sink { [weak self] gpsAlt, relAlt in
                self?.altitudeLabel.text = String(format: "ALT: %.1fm (GPS) | %.1fm (Rel)", gpsAlt, relAlt)
            }
            .store(in: &cancellables)
        
        locationManager.$speedMPH
            .sink { [weak self] speed in
                self?.speedLabel.text = String(format: "SPEED: %.1f MPH", max(0, speed))
            }
            .store(in: &cancellables)
        
        locationManager.$heading
            .sink { [weak self] heading in
                let direction = self?.headingToDirection(heading) ?? ""
                self?.headingLabel.text = String(format: "HEADING: %.1f° %@", heading, direction)
            }
            .store(in: &cancellables)
        
        motionManager.$roll
            .combineLatest(motionManager.$pitch, motionManager.$yaw)
            .sink { [weak self] roll, pitch, yaw in
                self?.orientationLabel.text = String(format: "ORIENT: R:%.1f° P:%.1f° Y:%.1f°", roll, pitch, yaw)
            }
            .store(in: &cancellables)
        
        motionManager.$accelerationX
            .combineLatest(motionManager.$accelerationY, motionManager.$accelerationZ)
            .sink { [weak self] x, y, z in
                self?.accelerationLabel.text = String(format: "ACCEL: X:%.2f Y:%.2f Z:%.2f g", x, y, z)
            }
            .store(in: &cancellables)
        
        motionManager.$rotationRateX
            .combineLatest(motionManager.$rotationRateY, motionManager.$rotationRateZ)
            .sink { [weak self] x, y, z in
                self?.rotationLabel.text = String(format: "ROTATION: X:%.1f Y:%.1f Z:%.1f °/s", x, y, z)
            }
            .store(in: &cancellables)
        
        motionManager.$pressure
            .sink { [weak self] pressure in
                self?.pressureLabel.text = String(format: "PRESSURE: %.2f kPa", pressure)
            }
            .store(in: &cancellables)
        
        motionManager.$stepCount
            .sink { [weak self] steps in
                self?.stepsLabel.text = String(format: "STEPS: %d", steps)
            }
            .store(in: &cancellables)
    }
    
    private func headingToDirection(_ heading: Double) -> String {
        let directions = ["N", "NE", "E", "SE", "S", "SW", "W", "NW"]
        let index = Int((heading + 22.5) / 45.0) % 8
        return directions[index]
    }
}
