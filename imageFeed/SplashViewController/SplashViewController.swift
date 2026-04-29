import UIKit

//MARK: - AuthViewControllerDelegate
protocol AuthViewControllerDelegate: AnyObject {
    func didAuthenticate(_ vc: AuthViewController, code: String)
}

final class SplashViewController: UIViewController {
    
    // MARK: - Public Properties
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    // MARK: - Private Properties
    private let storage = OAuth2TokenStorage.shared
    private let showAuthenticationScreenSegueIdentifier = SegueIdentifiers.showAuthScreen
    private let profileService = ProfileService.shared
    private var isProfileIsLoaded = false
    
    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackGround()
        setupLogo()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if OAuth2TokenStorage.shared.token != nil {
            guard let scene = view.window?.windowScene,
                  let delegate = scene.delegate as? SceneDelegate else { return }
            delegate.showMain()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    // MARK: - Private Methods
    private func fetchProfile(token: String) {
        UIBlockingProgressHUD.show()
        profileService.fetchProfile(token) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            guard let self else { return }
            
            switch result {
            case .success(let profile):
                ProfileImageService.shared.fetchProfileImageURL(username: profile.username) { _ in }
                guard let scene = self.view.window?.windowScene,
                      let sceneDelegate = scene.delegate as? SceneDelegate else {
                    assertionFailure("No SceneDelegate")
                    return
                }
                sceneDelegate.showMain()
                
            case .failure(let error):
                print("PROFILE ERROR:", error)
                print("Error \(error)")
                self.isProfileIsLoaded = false
                break
            }
        }
    }
    
    //MARK: UI Setting
    private let logoView = UIImageView()
    private func setupBackGround() {
        view.backgroundColor = UIColor(resource: .ifBackground)
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
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        guard let authViewController = storyboard.instantiateViewController(
            withIdentifier: "AuthViewController"
        ) as? AuthViewController else {
            assertionFailure("AuthViewController не создался")
            return
        }
        let navigationController = UINavigationController(rootViewController: authViewController)
        navigationController.modalPresentationStyle = .fullScreen
        
        present(navigationController, animated: true)
    }
}
