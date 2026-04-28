import Foundation

protocol ProfilePresenterProtocol: AnyObject {
    var view: ProfileViewControllerProtocol? { get set }
    func viewDidLoad()
    func viewWillAppear()
    func didTapLogout()
    func didConfirmLogout()
}

final class ProfilePresenter: ProfilePresenterProtocol {
    
    // MARK: - Public Properties
    weak var view: ProfileViewControllerProtocol?
    
    // MARK: - Private Properties
    private let profileService = ProfileService.shared
    private let imageService = ProfileImageService.shared
    
    private var profileServiceObserver: NSObjectProtocol?
    private var profileImageServiceObserver: NSObjectProtocol?
    
    private let logoutService: ProfileLogoutService
    
    // MARK: - Initializers
    init(logoutService: ProfileLogoutService = .shared) {
        self.logoutService = logoutService
    }
    
    // MARK: - Public Methods
    func present(profile: Profile) {
        let viewModel = ProfileViewModel(
            name: profile.name.isEmpty ? "Имя не указано" : profile.name,
            login: profile.loginName.isEmpty ? "Неизвестный пользователь" : profile.loginName,
            bio: profile.bio?.isEmpty == false ? profile.bio ?? "" : "Профиль не заполнен"
        )
        view?.display(profile: viewModel)
    }
    
    func didTapLogout() {
        view?.showLogoutConfirmation()
    }
    
    func didConfirmLogout() {
        logoutService.logout()
        view?.showLogoutFlow()
    }
    
    func viewDidLoad() {
        print("Presenter: viewDidLoad called")
        
        observeProfileServiceChanges()
        observeAvatarChanges()
        loadInitialData()
    }
    
    func viewWillAppear() {
        loadInitialData()
    }
    
    // MARK: - Private Methods
    private func observeProfileServiceChanges() {
        profileServiceObserver = NotificationCenter.default.addObserver(forName: ProfileService.didChangeNotification, object: nil, queue: .main) { [weak self] _ in
            print("Presenter: Received profile change notification")
            
            guard let self,
                  let profile = self.profileService.profile else {
                print("Presenter: No profile data in notification handler")
                return }
            
            self.present(profile: profile)
        }
    }
    
    private func observeAvatarChanges() {
        profileImageServiceObserver = NotificationCenter.default.addObserver(forName: ProfileImageService.didChangeNotification, object: nil, queue: .main) { [weak self] _ in
            guard let self,
                  let url = self.imageService.avatarURL else { return }
            
            self.view?.displayAvatar(urlString: url)
        }
    }
    
    private func loadInitialData() {
        print("loadInitialData called")

        if let profile = profileService.profile {
            print("Profile exists")
            present(profile: profile)
        } else {
            print("Profile is nil ❌")
        }

        if let url = imageService.avatarURL {
            print("Avatar exists")
            view?.displayAvatar(urlString: url)
        } else {
            print("Avatar is nil ❌")
        }
    }
    }

