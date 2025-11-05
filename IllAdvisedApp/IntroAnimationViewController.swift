import UIKit

class IntroAnimationViewController: UIViewController {
    
    private let phoneView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .darkGray
        view.layer.cornerRadius = 35
        view.layer.borderWidth = 8
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 20)
        view.layer.shadowRadius = 30
        view.layer.shadowOpacity = 0.8
        return view
    }()
    
    private let faceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 80)
        label.text = "😐"
        label.textAlignment = .center
        return label
    }()
    
    private let notchView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.layer.cornerRadius = 4
        return view
    }()
    
    private let cameraView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .darkGray
        view.layer.cornerRadius = 6
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 48, weight: .bold)
        label.text = "Ill Advised"
        label.textAlignment = .center
        label.alpha = 0
        return label
    }()
    
    private let taglineLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "Send it out in a blaze of glory"
        label.textColor = .systemGray
        label.textAlignment = .center
        label.alpha = 0
        return label
    }()
    
    private let explosionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 200)
        label.text = "💥"
        label.textAlignment = .center
        label.alpha = 0
        return label
    }()
    
    var onComplete: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 26/255, green: 26/255, blue: 46/255, alpha: 1.0)
        
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startAnimation()
    }
    
    private func setupUI() {
        view.addSubview(phoneView)
        phoneView.addSubview(notchView)
        phoneView.addSubview(cameraView)
        phoneView.addSubview(faceLabel)
        
        view.addSubview(explosionLabel)
        view.addSubview(titleLabel)
        view.addSubview(taglineLabel)
        
        NSLayoutConstraint.activate([
            phoneView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            phoneView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            phoneView.widthAnchor.constraint(equalToConstant: 200),
            phoneView.heightAnchor.constraint(equalToConstant: 400),
            
            notchView.topAnchor.constraint(equalTo: phoneView.topAnchor, constant: 15),
            notchView.centerXAnchor.constraint(equalTo: phoneView.centerXAnchor),
            notchView.widthAnchor.constraint(equalToConstant: 60),
            notchView.heightAnchor.constraint(equalToConstant: 8),
            
            cameraView.topAnchor.constraint(equalTo: phoneView.topAnchor, constant: 20),
            cameraView.centerXAnchor.constraint(equalTo: phoneView.centerXAnchor),
            cameraView.widthAnchor.constraint(equalToConstant: 12),
            cameraView.heightAnchor.constraint(equalToConstant: 12),
            
            faceLabel.centerXAnchor.constraint(equalTo: phoneView.centerXAnchor),
            faceLabel.centerYAnchor.constraint(equalTo: phoneView.centerYAnchor),
            
            explosionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            explosionLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            taglineLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            taglineLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        phoneView.transform = CGAffineTransform(translationX: 0, y: -view.bounds.height - 500)
            .rotated(by: 0)
            .scaledBy(x: 0.8, y: 0.8)
        phoneView.alpha = 0
    }
    
    private func startAnimation() {
        animatePhoneFall()
    }
    
    private func animatePhoneFall() {
        UIView.animateKeyframes(withDuration: 2.5, delay: 0.0, options: [.calculationModeCubic]) {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.1) {
                self.phoneView.alpha = 1
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.4) {
                self.phoneView.transform = CGAffineTransform(translationX: 0, y: 0)
                    .rotated(by: .pi)
                    .scaledBy(x: 1.0, y: 1.0)
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0.4, relativeDuration: 0.2) {
                self.phoneView.transform = CGAffineTransform(translationX: 0, y: 0)
                    .rotated(by: .pi * 2)
                    .scaledBy(x: 1.0, y: 1.0)
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 0.2) {
                self.phoneView.transform = CGAffineTransform(translationX: 0, y: 0)
                    .rotated(by: .pi * 3)
                    .scaledBy(x: 1.0, y: 1.0)
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0.8, relativeDuration: 0.1) {
                self.phoneView.transform = CGAffineTransform(translationX: 0, y: 0)
                    .rotated(by: .pi * 4)
                    .scaledBy(x: 1.05, y: 1.05)
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0.9, relativeDuration: 0.1) {
                self.phoneView.transform = CGAffineTransform(translationX: 0, y: 0)
                    .rotated(by: .pi * 4)
                    .scaledBy(x: 0, y: 0)
                self.phoneView.alpha = 0
            }
        }
        
        animateFaceReactions()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.3) {
            self.showExplosion()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.8) {
            self.showTitle()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
            self.completeAnimation()
        }
    }
    
    private func animateFaceReactions() {
        let faces = ["😐", "😮", "😨", "😱", "😵", "💀"]
        let timings = [0.0, 0.4, 0.8, 1.2, 1.8, 2.1]
        
        for (index, face) in faces.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + timings[index]) {
                self.faceLabel.text = face
            }
        }
    }
    
    private func showExplosion() {
        explosionLabel.alpha = 0
        explosionLabel.transform = CGAffineTransform(scaleX: 0, y: 0)
        
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseOut]) {
            self.explosionLabel.alpha = 1
            self.explosionLabel.transform = CGAffineTransform(scaleX: 1.2, y: 1.2).rotated(by: .pi)
        } completion: { _ in
            UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseIn]) {
                self.explosionLabel.alpha = 0
                self.explosionLabel.transform = CGAffineTransform(scaleX: 2, y: 2).rotated(by: .pi * 2)
            }
        }
    }
    
    private func showTitle() {
        titleLabel.transform = CGAffineTransform(translationX: 0, y: 20)
        taglineLabel.transform = CGAffineTransform(translationX: 0, y: 10)
        
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseOut]) {
            self.titleLabel.alpha = 1
            self.titleLabel.transform = .identity
        }
        
        UIView.animate(withDuration: 0.5, delay: 0.3, options: [.curveEaseOut]) {
            self.taglineLabel.alpha = 1
            self.taglineLabel.transform = .identity
        }
    }
    
    private func completeAnimation() {
        onComplete?()
    }
}
