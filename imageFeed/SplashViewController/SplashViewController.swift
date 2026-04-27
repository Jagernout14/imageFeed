import UIKit

//MARK: - AuthViewControllerDelegate
protocol AuthViewControllerDelegate: AnyObject {
    func didAuthenticate(_ vc: AuthViewController)
}

final class SplashViewController: UIViewController {
    
    // MARK: - Public Properties
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    // MARK: - Private Properties
    private let storage = OAuth2TokenStorage.shared
    private let showAuthenticationScreenSegueIdentifier = "ShowAuthScreen"
    private let profileService = ProfileService.shared
    private var isProfileIsLoaded = false
    private var isPresentingAuth = false
    private var isAuthFlowFinished = false
    
    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackGround()
        setupLogo()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard !isProfileIsLoaded,
              !isAuthFlowFinished else { return }
        
        guard let token = storage.token else {
            presentAuthViewController()
            return
        }
        
        isProfileIsLoaded = true
        fetchProfile(token: token)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    // MARK: - Private Methods
    private func switchToTabBarController() {
        guard let scene = view.window?.windowScene,
              let sceneDelegate = scene.delegate as? SceneDelegate,
              let window = sceneDelegate.window else {
            assertionFailure("Invalid window configuration")
            return
        }
        
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }
    
    private func fetchProfile(token: String) {
        UIBlockingProgressHUD.show()
        profileService.fetchProfile(token) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            guard let self else { return }
            
            switch result {
            case .success(let profile):
                ProfileImageService.shared.fetchProfileImageURL(username: profile.username) { _ in }
                self.switchToTabBarController()
                
            case .failure(let error):
                print("Error \(error)")
                self.isProfileIsLoaded = false
                break
            }
        }
    }
    
    //MARK: UI Setting
    private let logoView = UIImageView()
    private func setupBackGround() {
        view.backgroundColor = UIColor(named: "IF_Background")
    }
    
    private func setupLogo() {
        let splashScreenLogo = UIImage(named: "LaunchScreenLogo")
        logoView.image = splashScreenLogo
        logoView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoView)
        logoView.widthAnchor.constraint(equalToConstant: 75).isActive = true
        logoView.heightAnchor.constraint(equalToConstant: 78).isActive = true
        logoView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        logoView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    //MARK: Segue to AuthViewController
    private func presentAuthViewController() {
        guard !isPresentingAuth else { return }
        isPresentingAuth = true
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
        guard let authViewController = storyboard.instantiateViewController(withIdentifier: "AuthViewController") as? AuthViewController else {
            assertionFailure("AuthViewController не создался")
            return
        }
        
        authViewController.delegate = self
        let navigationController = UINavigationController(rootViewController: authViewController)
        navigationController.modalPresentationStyle = .fullScreen
        
        present(navigationController, animated: true) { [weak self] in
            self?.isPresentingAuth = false
        }
    }
}

//MARK: - AuthViewControllerDelegate
extension SplashViewController: AuthViewControllerDelegate {
    func didAuthenticate(_ vc: AuthViewController) {
        isAuthFlowFinished = true
        vc.dismiss(animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            guard let token = self.storage.token else { return }
            self.isProfileIsLoaded = true
            self.fetchProfile(token: token)
        }
    }
}
