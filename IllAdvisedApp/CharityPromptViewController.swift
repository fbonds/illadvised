import UIKit
import SafariServices

class CharityPromptViewController: UIViewController {
    
    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "A Note on Privilege"
        return label
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.text = """
        This app exists as a commentary on first-world excess.
        
        The ability to intentionally destroy a device that costs hundreds of dollars—a device that many people globally cannot afford and would treasure—is a stark illustration of wealth inequality.
        
        This app is free and we don't profit from it. But we ask that you acknowledge this privilege by making a donation to help bridge the digital divide.
        
        Consider it the real "price" of the app.
        """
        return label
    }()
    
    private let charitiesHeaderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.text = "Please Donate To:"
        return label
    }()
    
    private let charitiesStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 12
        return stack
    }()
    
    private let continueButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("I Understand", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        return button
    }()
    
    private let acknowledgeCheckbox: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "square"), for: .normal)
        button.setImage(UIImage(systemName: "checkmark.square.fill"), for: .selected)
        button.tintColor = .systemBlue
        return button
    }()
    
    private let acknowledgeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.text = "I acknowledge my privilege and commit to making a donation"
        return label
    }()
    
    private var hasAcknowledged = false
    
    struct Charity {
        let name: String
        let description: String
        let url: String
    }
    
    private let charities = [
        Charity(name: "EveryoneOn", 
                description: "Connecting low-income families to affordable internet and computers",
                url: "https://www.everyoneon.org/donate"),
        Charity(name: "PCs for People",
                description: "Provides refurbished computers and internet to those in need",
                url: "https://www.pcsforpeople.org/donate/"),
        Charity(name: "World Computer Exchange",
                description: "Delivers technology to underserved communities globally",
                url: "https://worldcomputerexchange.org/donate"),
        Charity(name: "Computers With Causes",
                description: "Gives computers to families, students, and nonprofits",
                url: "https://www.computerswithcauses.org/donate/"),
        Charity(name: "Direct Relief",
                description: "Emergency and medical assistance worldwide",
                url: "https://www.directrelief.org/donate/"),
        Charity(name: "Doctors Without Borders",
                description: "Medical humanitarian aid in crisis zones",
                url: "https://donate.doctorswithoutborders.org/"),
        Charity(name: "World Central Kitchen",
                description: "Food relief in disaster areas",
                url: "https://donate.wck.org/"),
        Charity(name: "GiveDirectly",
                description: "Direct cash transfers to people in poverty",
                url: "https://www.givedirectly.org/donate/")
    ]
    
    var onContinue: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        setupCharityButtons()
    }
    
    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(messageLabel)
        contentView.addSubview(charitiesHeaderLabel)
        contentView.addSubview(charitiesStack)
        
        let acknowledgeStack = UIStackView(arrangedSubviews: [acknowledgeCheckbox, acknowledgeLabel])
        acknowledgeStack.translatesAutoresizingMaskIntoConstraints = false
        acknowledgeStack.axis = .horizontal
        acknowledgeStack.spacing = 12
        acknowledgeStack.alignment = .top
        contentView.addSubview(acknowledgeStack)
        
        contentView.addSubview(continueButton)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            messageLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            messageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            charitiesHeaderLabel.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 32),
            charitiesHeaderLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            charitiesHeaderLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            charitiesStack.topAnchor.constraint(equalTo: charitiesHeaderLabel.bottomAnchor, constant: 16),
            charitiesStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            charitiesStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            acknowledgeStack.topAnchor.constraint(equalTo: charitiesStack.bottomAnchor, constant: 32),
            acknowledgeStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            acknowledgeStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            acknowledgeCheckbox.widthAnchor.constraint(equalToConstant: 30),
            acknowledgeCheckbox.heightAnchor.constraint(equalToConstant: 30),
            
            continueButton.topAnchor.constraint(equalTo: acknowledgeStack.bottomAnchor, constant: 32),
            continueButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            continueButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            continueButton.heightAnchor.constraint(equalToConstant: 50),
            continueButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40)
        ])
        
        acknowledgeCheckbox.addTarget(self, action: #selector(checkboxTapped), for: .touchUpInside)
        continueButton.addTarget(self, action: #selector(continueTapped), for: .touchUpInside)
        continueButton.alpha = 0.5
        continueButton.isEnabled = false
    }
    
    private func setupCharityButtons() {
        for charity in charities {
            let charityView = createCharityButton(charity: charity)
            charitiesStack.addArrangedSubview(charityView)
        }
    }
    
    private func createCharityButton(charity: Charity) -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = .systemGray6
        container.layer.cornerRadius = 12
        
        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        nameLabel.text = charity.name
        
        let descLabel = UILabel()
        descLabel.translatesAutoresizingMaskIntoConstraints = false
        descLabel.font = UIFont.systemFont(ofSize: 14)
        descLabel.textColor = .secondaryLabel
        descLabel.numberOfLines = 0
        descLabel.text = charity.description
        
        let donateButton = UIButton(type: .system)
        donateButton.translatesAutoresizingMaskIntoConstraints = false
        donateButton.setTitle("Donate →", for: .normal)
        donateButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        
        container.addSubview(nameLabel)
        container.addSubview(descLabel)
        container.addSubview(donateButton)
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 12),
            nameLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: donateButton.leadingAnchor, constant: -8),
            
            descLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            descLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            descLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            descLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -12),
            
            donateButton.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),
            donateButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16)
        ])
        
        donateButton.addAction(UIAction { [weak self] _ in
            self?.openCharityURL(charity.url)
        }, for: .touchUpInside)
        
        return container
    }
    
    private func openCharityURL(_ urlString: String) {
        guard let url = URL(string: urlString) else { return }
        let safari = SFSafariViewController(url: url)
        present(safari, animated: true)
    }
    
    @objc private func checkboxTapped() {
        hasAcknowledged.toggle()
        acknowledgeCheckbox.isSelected = hasAcknowledged
        
        UIView.animate(withDuration: 0.3) {
            self.continueButton.alpha = self.hasAcknowledged ? 1.0 : 0.5
        }
        continueButton.isEnabled = hasAcknowledged
    }
    
    @objc private func continueTapped() {
        UserDefaults.standard.set(true, forKey: "HasSeenCharityPrompt")
        onContinue?()
        dismiss(animated: true)
    }
}
