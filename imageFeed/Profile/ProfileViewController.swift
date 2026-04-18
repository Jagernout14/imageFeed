import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    
    // MARK: - Public Properties
    enum SystemImage: String {
        case avatar = "person.circle.fill"
        
        func image(pointSize: CGFloat, weight: UIImage.SymbolWeight = .regular, scale: UIImage.SymbolScale = .default) -> UIImage? {
            let config = UIImage.SymbolConfiguration(pointSize: pointSize, weight: weight, scale: scale)
            return UIImage(systemName: rawValue)?.withConfiguration(config)
        }
    }
    
    // MARK: - Private Properties
    private let avatarPicView = UIImageView()
    private let usernameLabel = UILabel()
    private let accountLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let logoutButton = UIButton(type: .system)
    
    private let profileService = ProfileService.shared
    
    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        if let profile = ProfileService.shared.profile {
            updateProfileDetails(with: profile)
        }
        
        setupAvatar()
        setupNameLabel()
        setupAccountLabel()
        setupDescriptionLabel()
        setupLogoutButton()
        setupBackground()
        
        profileImageServiceObserver = NotificationCenter.default.addObserver(forName: ProfileImageService.didChangeNotification, object: nil, queue: .main) { [weak self] _ in
            guard let self else { return }
            
            self.updateAvatar()
        }
        updateAvatar()
        
        profileServiceObserver = NotificationCenter.default.addObserver(forName: ProfileService.didChangeNotification, object: nil, queue: .main) { [weak self] _ in
            guard let self else { return }
            
            if let profile = self.profileService.profile {
                self.updateProfileDetails(with: profile)
            }
        }
    }
    
    // MARK: - Observer Construction
    private var profileImageServiceObserver: NSObjectProtocol?
    private var profileServiceObserver: NSObjectProtocol?
    
    private func updateAvatar() {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }
        
        let placeholderImage = SystemImage.avatar.image(pointSize: 70)?.withTintColor(.lightGray, renderingMode: .alwaysOriginal)
        
        let processor = RoundCornerImageProcessor(cornerRadius: 35)
        avatarPicView.kf.indicatorType = .activity
        avatarPicView.kf.setImage(with: url, placeholder: placeholderImage, options: [
            .processor(processor),
            .scaleFactor(UIScreen.main.scale),
            .cacheOriginalImage,
            .forceRefresh
        ]) { result in
            switch result {
            case .success(let value):
                print(value.image)
                print(value.cacheType)
                print(value.source)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // MARK: - Private Methods
    @objc private func didTapLogoutButton() {
        ProfileLogoutService.shared.logout()
        
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let delegate = scene.delegate as? SceneDelegate else { return }
        delegate.switchToMain()
    }
    
    private func updateProfileDetails(with profile: Profile) {
        usernameLabel.text = profile.name.isEmpty ? "Имя не указано" : profile.name
        accountLabel.text = profile.loginName.isEmpty ? "Неизвестный пользователь" : profile.loginName
        descriptionLabel.text = (profile.bio?.isEmpty ?? true) ? "Профиль не заполнен" : profile.bio
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
        view.addSubview(usernameLabel)
        usernameLabel.topAnchor.constraint(equalTo: avatarPicView.bottomAnchor, constant: 8).isActive = true
        usernameLabel.leadingAnchor.constraint(equalTo: avatarPicView.leadingAnchor).isActive = true
    }
    
    private func setupAccountLabel() {
        accountLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        accountLabel.textColor = UIColor(resource: .ifGrey)
        accountLabel.translatesAutoresizingMaskIntoConstraints = false
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
