import UIKit
final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    static weak var shared: SceneDelegate?
    var window: UIWindow?
    
    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = scene as? UIWindowScene else { return }
        SceneDelegate.shared = self
        
        window = UIWindow(windowScene: windowScene)
        
        if OAuth2TokenStorage.shared.token != nil {
            showMain()
        } else {
            showAuth()
        }
        window?.makeKeyAndVisible()
    }
    
    func showSplash() {
        let splash = SplashViewController()
        window?.rootViewController = splash
    }
    
    func showMain() {
        let tabBar = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        
        window?.rootViewController = tabBar
        
        loadProfileIfNeeded()
    }
    
    func showAuth() {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        guard let authVC = storyboard.instantiateViewController(
            withIdentifier: "AuthViewController"
        ) as? AuthViewController else {
            return
        }
        let nav = UINavigationController(rootViewController: authVC)
        window?.rootViewController = nav
    }
    
    private func loadProfileIfNeeded() {
        guard
            let token = OAuth2TokenStorage.shared.token
        else { return }
        
        ProfileService.shared.fetchProfile(token) { result in
            switch result {
            case .success(let profile):
                ProfileService.shared.updateProfile(profile)
                ProfileImageService.shared.fetchProfileImageURL(
                    username: profile.username
                ) { _ in }
                
            case .failure(let error):
                print("Profile load error:", error)
            }
        }
    }
}

extension SceneDelegate: AuthViewControllerDelegate {
    
    func didAuthenticate(_ vc: AuthViewController, code: String) {
        OAuth2Service.shared.fetchOAuthToken(code: code) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let token):
                OAuth2TokenStorage.shared.token = token
                ProfileService.shared.fetchProfile(token) { profileResult in
                    switch profileResult {
                    case .success(let profile):
                        ProfileService.shared.updateProfile(profile)
                        ProfileImageService.shared.fetchProfileImageURL(username: profile.username) { _ in }
                        
                        DispatchQueue.main.async {
                            vc.dismiss(animated: true) {
                                self.showMain()
                            }
                        }
                        
                    case .failure(let error):
                        print("Profile error:", error)
                    }
                }
                
            case .failure(let error):
                print("Auth error:", error)
            }
        }
    }
}
