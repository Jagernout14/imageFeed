import UIKit

final class LoginFlowCoordinator {
    
    // MARK: - Private Properties
    private let window: UIWindow
    private let profileService = ProfileService.shared
    private let tokenStorage = OAuth2TokenStorage.shared
    private let imageService = ProfileImageService.shared
    
    // MARK: - Initializers
    init(window: UIWindow) {
        self.window = window
    }
    
    // MARK: - Public Methods
    func start() {
        showSplash()
    }
    
    // MARK: - Private Methods
    private func showSplash() {
        let splash = SplashViewController()
        splash.delegate = self
        window.rootViewController = splash
    }
    
    private func showMainWithProfile() {
        guard let token = tokenStorage.token else {
            showAuth()
            return
        }
        
        UIBlockingProgressHUD.show()
        
        profileService.fetchProfile(token) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let profile):
                self.profileService.updateProfile(profile)
                self.imageService.fetchProfileImageURL(username: profile.username) { _ in }
                
                DispatchQueue.main.async {
                    UIBlockingProgressHUD.dismiss()
                    self.showMain()
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    UIBlockingProgressHUD.dismiss()
                }
                print("Profile error:", error)
                self.showAuth()
            }
        }
    }
    
    private func showAuth() {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        guard let authViewController = storyboard.instantiateViewController(
            withIdentifier: "AuthViewController"
        ) as? AuthViewController else {
            return
        }
        authViewController.navigationDelegate = self
        let nav = UINavigationController(rootViewController: authViewController)
        window.rootViewController = nav
    }
    
    private func showMain() {
        let tabBar = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        
        window.rootViewController = tabBar
    }
}

//MARK: - AuthNavigationDelegate
extension LoginFlowCoordinator: AuthNavigationDelegate {
    func authViewControllerDidAuthenticate(_ viewController: AuthViewController) {
        showMainWithProfile()
    }
    
    func authViewControllerDidCancel(_ viewController: AuthViewController) {
        print("Auth cancelled")
    }
    
    func authViewController(_ viewController: AuthViewController, didFailWith error: Error) {
        print("Auth error:", error)
    }
}

//MARK: - SplashViewControllerDelegate
extension LoginFlowCoordinator: SplashViewControllerDelegate {
    func splashDidFinish(_ viewController: SplashViewController) {
        if tokenStorage.token != nil {
            showMainWithProfile()
        } else {
            showAuth()
        }
    }
}

//MARK: - ProfilePresenterDelegate
extension LoginFlowCoordinator: ProfilePresenterDelegate {
    func didLogout() {
        showAuth()
    }
}
