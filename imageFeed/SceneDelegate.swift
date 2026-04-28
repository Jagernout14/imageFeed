import UIKit
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
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
}

extension SceneDelegate: AuthViewControllerDelegate {
    
    func didAuthenticate(_ vc: AuthViewController) {
        vc.dismiss(animated: true)
        showMain()
    }
    
    /*  func didAuthenticate(_ vc: AuthViewController) {
        OAuth2Service.shared.fetchOAuthToken(code: code) { result in
            switch result {
            case .success(let token):
                OAuth2TokenStorage.shared.token = token

                ProfileService.shared.fetchProfile()
                ProfileImageService.shared.fetchAvatar()

                vc.dismiss(animated: true)
                self.showMain()

            case .failure:
                break
            }
        } */
    }

