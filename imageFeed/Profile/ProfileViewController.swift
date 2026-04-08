import UIKit

final class ProfileViewController: UIViewController {
    
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
        
        /*if let avatarURL = ProfileImageService.shared.avatarURL,
         let url = URL(string: avatarURL) {
         //TODO: Kingfisher
         } */
        profileImageServiceObserver = NotificationCenter.default.addObserver(forName: ProfileImageService.didChangeNotification, object: nil, queue: .main) { [weak self] _ in
            guard let self else {
                return
            }
            self.updateAvatar()
        }
        updateAvatar()
    }
    
    // MARK: - Observer Construction
    private var profileImageServiceObserver: NSObjectProtocol?
    
    private func updateAvatar() {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL)
        else {
            return
        }
        //TODO: Kingfisher
    }
    
    /*override init(nibName: String?, bundle: Bundle?) {
     super.init(nibName: nibName, bundle: bundle)
     addObserver()
     }
     
     required init?(coder: NSCoder) {
     super.init(coder: coder)
     addObserver()
     }
     
     deinit {
     removeObserver()
     }
     
     private func addObserver() {
     NotificationCenter.default.addObserver(self, selector: #selector(updateAvatar(notification:)), name: ProfileImageService.didChangeNotification, object: nil)
     }
     
     private func removeObserver() {
     NotificationCenter.default.removeObserver(self, name: ProfileImageService.didChangeNotification, object: nil)
     }
     
     @objc
     private func updateAvatar(notification: Notification) {
     guard isViewLoaded,
     let userInfo = notification.userInfo,
     let profileImageURL = userInfo["URL"] as? String,
     let url = URL(string: profileImageURL)
     else {
     return
     }
     
     //TODO: Kingfisher
     }
     */
    
    // MARK: - Private Methods
    private func updateProfileDetails(with profile: Profile) {
        usernameLabel.text = profile.name.isEmpty ? "Имя не указано" : profile.name
        accountLabel.text = profile.loginName.isEmpty ? "Неизвестный пользователь" : profile.loginName
        descriptionLabel.text = (profile.bio?.isEmpty ?? true) ? "Профиль не заполнен" : profile.bio
    }
    
    // MARK: - UI Settings
    private func setupAvatar() {
        let avatarPic = UIImage(named: "UserPic")
        avatarPicView.image = avatarPic
        avatarPicView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(avatarPicView)
        avatarPicView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        avatarPicView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        avatarPicView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
        avatarPicView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
    }
    
    private func setupNameLabel() {
        usernameLabel.text = "Екатерина Новикова"
        usernameLabel.font = UIFont.boldSystemFont(ofSize: 23)
        usernameLabel.textColor = UIColor(named: "IF_White")
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(usernameLabel)
        usernameLabel.topAnchor.constraint(equalTo: avatarPicView.bottomAnchor, constant: 8).isActive = true
        usernameLabel.leadingAnchor.constraint(equalTo: avatarPicView.leadingAnchor).isActive = true
    }
    
    private func setupAccountLabel() {
        accountLabel.text = "@ekaterina_nov"
        accountLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        accountLabel.textColor = UIColor(named: "IF_Grey")
        accountLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(accountLabel)
        accountLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 8).isActive = true
        accountLabel.leadingAnchor.constraint(equalTo: avatarPicView.leadingAnchor).isActive = true
    }
    
    private func setupDescriptionLabel() {
        descriptionLabel.text = "Hello, world!"
        descriptionLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        descriptionLabel.textColor = UIColor(named: "IF_White")
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)
        descriptionLabel.topAnchor.constraint(equalTo: accountLabel.bottomAnchor, constant: 8).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: avatarPicView.leadingAnchor).isActive = true
    }
    
    private func setupLogoutButton() {
        logoutButton.setImage(UIImage(named: "Exit_icon"), for: .normal)
        logoutButton.tintColor = UIColor(named: "IF_Red")
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoutButton)
        logoutButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
        logoutButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        logoutButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 45).isActive = true
    }
}
