import UIKit

//MARK: - AuthViewControllerDelegate
protocol AuthViewControllerDelegate: AnyObject {
    func didAuthenticate(_ vc: AuthViewController, code: String)
}

protocol SplashViewControllerDelegate: AnyObject {
    func splashDidFinish(_ viewController: SplashViewController)
}

final class SplashViewController: UIViewController {
    
    // MARK: - Public Properties
    weak var delegate: SplashViewControllerDelegate?
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackGround()
        setupLogo()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.delegate?.splashDidFinish(self)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
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
}
