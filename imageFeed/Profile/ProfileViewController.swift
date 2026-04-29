import UIKit
import Kingfisher

protocol ProfileViewControllerProtocol: AnyObject {
    func display(profile: ProfileViewModel)
    func displayAvatar(urlString: String)
    func showLogoutConfirmation()
}

final class ProfileViewController: UIViewController {
    
    // MARK: - Public Properties
    var presenter: ProfilePresenterProtocol?    
    enum SystemImage: String {
        case avatar = "person.circle.fill"
        func image(pointSize: CGFloat, weight: UIImage.SymbolWeight = .regular, scale: UIImage.SymbolScale = .default) -> UIImage? {
            let config = UIImage.SymbolConfiguration(pointSize: pointSize, weight: weight, scale: scale)
            return UIImage(systemName: rawValue)?.withConfiguration(config)
        }
    }
    
    // MARK: - Private Properties
    private lazy var avatarPicView = UIImageView()
    private lazy var usernameLabel = UILabel()
    private lazy var accountLabel = UILabel()
    private lazy var descriptionLabel = UILabel()
    private lazy var logoutButton = UIButton(type: .system)
    
    private var isProfileLoaded = false
    private var isAvatarLoaded = false
    private let fadingView = UIView()
    
    
    
    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.accessibilityIdentifier = AccessibilityIdentifiers.ProfileView.ProfileViewControllerIdentifier
        setupUI()
        presenter?.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isProfileLoaded = false
        isAvatarLoaded = false
    }
    
    // MARK: - Public Methods
    func showLogoutConfirmation() {
        let alert = UIAlertController(
            title: "Пока, Пока!",
            message: "Уверены, что хотите выйти?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Нет", style: .cancel))
        alert.addAction(UIAlertAction(title: "Да", style: .default) { [weak self] _ in
            self?.presenter?.didConfirmLogout()
        })
        
        present(alert, animated: true)
    }
    
    // MARK: - Private Methods
    @objc private func didTapLogoutButton() {
        
        presenter?.didTapLogout()
    }
    
    private func setupUI() {
        setupAvatar()
        setupNameLabel()
        setupAccountLabel()
        setupDescriptionLabel()
        setupLogoutButton()
        setupBackground()
    }
    
    // MARK: - UI Settings
    private func setupAvatar() {
        let avatarPic = UIImage(resource: .userPic)
        avatarPicView.image = avatarPic
        avatarPicView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(avatarPicView)
        avatarPicView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        avatarPicView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        avatarPicView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
        avatarPicView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
    }
    
    private func setupNameLabel() {
        usernameLabel.font = UIFont.boldSystemFont(ofSize: 23)
        usernameLabel.textColor = UIColor(resource: .ifWhite)
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.accessibilityIdentifier = AccessibilityIdentifiers.ProfileView.usernameLabel
        
        view.addSubview(usernameLabel)
        usernameLabel.topAnchor.constraint(equalTo: avatarPicView.bottomAnchor, constant: 8).isActive = true
        usernameLabel.leadingAnchor.constraint(equalTo: avatarPicView.leadingAnchor).isActive = true
    }
    
    private func setupAccountLabel() {
        accountLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        accountLabel.textColor = UIColor(resource: .ifGrey)
        accountLabel.translatesAutoresizingMaskIntoConstraints = false
        accountLabel.accessibilityIdentifier = AccessibilityIdentifiers.ProfileView.accountLabel
        view.addSubview(accountLabel)
        accountLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 8).isActive = true
        accountLabel.leadingAnchor.constraint(equalTo: avatarPicView.leadingAnchor).isActive = true
    }
    
    private func setupDescriptionLabel() {
        descriptionLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        descriptionLabel.textColor = UIColor(resource: .ifWhite)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)
        descriptionLabel.topAnchor.constraint(equalTo: accountLabel.bottomAnchor, constant: 8).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: avatarPicView.leadingAnchor).isActive = true
    }
    
    private func setupLogoutButton() {
        logoutButton.setImage(UIImage(resource: .exitIcon), for: .normal)
        logoutButton.tintColor = UIColor(resource: .ifRed)
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.accessibilityIdentifier = AccessibilityIdentifiers.ProfileView.logoutButton
        view.addSubview(logoutButton)
        logoutButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
        logoutButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        logoutButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 45).isActive = true
        logoutButton.addTarget(self, action: #selector(didTapLogoutButton), for: .touchUpInside)
    }
    
    private func setupBackground() {
        view.backgroundColor = UIColor(resource: .ifBackground)
    }
}

//MARK: - ProfileViewControllerProtocol
extension ProfileViewController: ProfileViewControllerProtocol {
    
    func display(profile: ProfileViewModel) {
        usernameLabel.text = profile.name
        accountLabel.text = profile.login
        descriptionLabel.text = profile.bio
        
        isProfileLoaded = true
    }
    
    func displayAvatar(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        let placeholderImage = SystemImage.avatar.image(pointSize: 70)?.withTintColor(.lightGray, renderingMode: .alwaysOriginal)
        
        let processor = RoundCornerImageProcessor(cornerRadius: 35)
        avatarPicView.kf.indicatorType = .activity
        avatarPicView.kf.setImage(with: url, placeholder: placeholderImage, options: [
            .processor(processor),
            .scaleFactor(UIScreen.main.scale),
            .cacheOriginalImage,
            .forceRefresh
        ]
        ) { [weak self] _ in
            self?.isAvatarLoaded = true
        }
    }
}
