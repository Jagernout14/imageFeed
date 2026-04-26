import Foundation

protocol ProfileViewPresenterProtocol: AnyObject {
    var view: ProfileViewControllerProtocol? { get set }
    func viewDidLoad()
    func performLogout()
}

final class ProfileViewPresenter: ProfileViewPresenterProtocol {
    
    // MARK: - Public Properties
    weak var view: ProfileViewControllerProtocol?
    
    // MARK: - Private Properties
    private let profileService = ProfileService.shared
    private let imageService = ProfileImageService.shared
    
    private var profileServiceObserver: NSObjectProtocol?
    private var profileImageServiceObserver: NSObjectProtocol?
    
    // MARK: - Public Methods
    func present(profile: Profile) {
        let viewModel = ProfileViewModel(
            name: profile.name.isEmpty ? "Имя не указано" : profile.name,
            login: profile.loginName.isEmpty ? "Неизвестный пользователь" : profile.loginName,
            bio: profile.bio?.isEmpty == false ? profile.bio ?? "" : "Профиль не заполнен"
        )
        
        view?.display(profile: viewModel)
    }
    
    func performLogout() {
        ProfileLogoutService.shared.logout()
        view?.showLogoutFlow()
    }
    
    func viewDidLoad() {
        observeProfileServiceChanges()
        observeAvatarChanges()
        loadInitialData()
    }
    
    // MARK: - Private Methods
    private func observeProfileServiceChanges() {
        profileServiceObserver = NotificationCenter.default.addObserver(forName: ProfileService.didChangeNotification, object: nil, queue: .main) { [weak self] _ in
            guard let self,
                  let profile = self.profileService.profile else { return }
            
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
        if let profile = profileService.profile {
            present(profile: profile)
        }
        if let url = imageService.avatarURL {
            view?.displayAvatar(urlString: url)
        }
    }
}
