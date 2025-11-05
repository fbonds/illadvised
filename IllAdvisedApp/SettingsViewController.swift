import UIKit
import Combine

class SettingsViewController: UIViewController {
    private var authManager: SocialMediaAuthManager?
    private var cancellables = Set<AnyCancellable>()
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(PlatformCell.self, forCellReuseIdentifier: "PlatformCell")
        return table
    }()
    
    private var platforms: [SocialMediaAuthManager.Platform] {
        return FeatureFlags.enableSocialMediaStreaming ? SocialMediaAuthManager.Platform.allCases : []
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Settings"
        view.backgroundColor = .systemBackground
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(doneTapped)
        )
        
        setupUI()
        setupBindings()
    }
    
    private func setupUI() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func setupBindings() {
        if FeatureFlags.enableSocialMediaStreaming {
            authManager = SocialMediaAuthManager()
            authManager?.$authenticatedPlatforms
                .sink { [weak self] _ in
                    self?.tableView.reloadData()
                }
                .store(in: &cancellables)
        }
    }
    
    @objc private func doneTapped() {
        dismiss(animated: true)
    }
    
    private func authenticatePlatform(_ platform: SocialMediaAuthManager.Platform) {
        guard let authManager = authManager else { return }
        authManager.authenticate(platform: platform) { [weak self] result in
            switch result {
            case .success:
                self?.showAlert(title: "Success", message: "Connected to \(platform.rawValue)")
            case .failure(let error):
                self?.showAlert(title: "Error", message: "Failed to connect: \(error.localizedDescription)")
            }
        }
    }
    
    private func disconnectPlatform(_ platform: SocialMediaAuthManager.Platform) {
        guard let authManager = authManager else { return }
        let alert = UIAlertController(
            title: "Disconnect",
            message: "Are you sure you want to disconnect from \(platform.rawValue)?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Disconnect", style: .destructive) { _ in
            authManager.disconnect(platform: platform)
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return FeatureFlags.enableSocialMediaStreaming ? 2 : 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if FeatureFlags.enableSocialMediaStreaming && section == 0 {
            return platforms.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if FeatureFlags.enableSocialMediaStreaming && section == 0 {
            return "Connected Platforms"
        }
        return "About"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if FeatureFlags.enableSocialMediaStreaming && indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PlatformCell", for: indexPath) as! PlatformCell
            let platform = platforms[indexPath.row]
            let isConnected = authManager?.authenticatedPlatforms[platform] != nil
            cell.configure(platform: platform.rawValue, isConnected: isConnected)
            return cell
        } else {
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "AboutCell")
            cell.textLabel?.text = "Ill Advised"
            cell.detailTextLabel?.text = "Version 1.0"
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard FeatureFlags.enableSocialMediaStreaming && indexPath.section == 0 else { return }
        
        let platform = platforms[indexPath.row]
        let isConnected = authManager?.authenticatedPlatforms[platform] != nil
        
        if isConnected {
            disconnectPlatform(platform)
        } else {
            authenticatePlatform(platform)
        }
    }
}

class PlatformCell: UITableViewCell {
    private let platformLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .systemGray
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        contentView.addSubview(platformLabel)
        contentView.addSubview(statusLabel)
        
        NSLayoutConstraint.activate([
            platformLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            platformLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            statusLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            statusLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func configure(platform: String, isConnected: Bool) {
        platformLabel.text = platform
        statusLabel.text = isConnected ? "Connected" : "Not Connected"
        statusLabel.textColor = isConnected ? .systemGreen : .systemGray
    }
}
