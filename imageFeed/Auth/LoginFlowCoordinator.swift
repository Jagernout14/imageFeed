import UIKit

final class LoginFlowCoordinator {
    
    // MARK: - Private Properties
    private let window: UIWindow
    private let profileService = ProfileService.shared
    private let tokenStorage = OAuth2TokenStorage.shared
    private let imageService = ProfileImageService.shared
    private var isAuthenticating = false
    
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
            DispatchQueue.main.async {
                guard let self else { return }
                
                switch result {
                case .success(let profile):
                    self.profileService.updateProfile(profile)
                    self.imageService.fetchProfileImageURL(username: profile.username) { _ in }
                    
                    UIBlockingProgressHUD.dismiss()
                    self.showMain()
                    
                case .failure(let error):
                    UIBlockingProgressHUD.dismiss()
                    print("Profile error:", error)
                    self.showAuth()
                }
            }
        }
    }
    
    private func showAuth() {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        guard let authViewController = storyboard.instantiateViewController(
            withIdentifier: AccessibilityIdentifiers.AuthViewController.authViewController
        ) as? AuthViewController else {
            return
        }
        authViewController.navigationDelegate = self
        let nav = UINavigationController(rootViewController: authViewController)
        window.rootViewController = nav
    }
    
    private func showMain() {
        let tabBar = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(
                withIdentifier: AccessibilityIdentifiers.TabBarController.tabBarController
            ) as! TabBarController
        
        tabBar.logoutDelegate = self
        
        window.rootViewController = tabBar
    }
    
    private func showWebView() {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
        guard let webViewController = storyboard.instantiateViewController(
            withIdentifier: AccessibilityIdentifiers.WebView.webView
        ) as? WebViewViewController else { return }
        
        let authHelper = AuthHelper(configuration: AuthConfiguration.standard)
        let presenter = WebViewPresenter(authHelper: authHelper)
        webViewController.presenter = presenter
        presenter.view = webViewController
        webViewController.delegate = self
        
        guard let nav = window.rootViewController as? UINavigationController else { return }
        nav.pushViewController(webViewController, animated: true)
    }
}

//MARK: - AuthNavigationDelegate
extension LoginFlowCoordinator: AuthNavigationDelegate {
    func authViewControllerDidAuthenticate(_ viewController: AuthViewController) {
        showWebView()
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
            showMain()
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

//MARK: - WebViewViewControllerDelegate
extension LoginFlowCoordinator: WebViewViewControllerDelegate {
    
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        vc.dismiss(animated: true)
        UIBlockingProgressHUD.show()
        OAuth2Service.shared.fetchOAuthToken(code: code) { [weak self] result in
            DispatchQueue.main.async {
                UIBlockingProgressHUD.dismiss()
                guard let self else { return }
                
                switch result {
                case .success(let token):
                    OAuth2TokenStorage.shared.token = token
                    self.showMain()
                    
                case .failure(let error):
                    print(error)
                    self.showAuth()
                }
            }
        }
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        vc.dismiss(animated: true)
    }
}

//MARK: - ProfilePresenterDelegate
extension LoginFlowCoordinator: TabBarControllerDelegate {
    func tabBarDidLogout() {
        showAuth()
    }
}
