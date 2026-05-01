import UIKit
import ProgressHUD

protocol AuthNavigationDelegate: AnyObject {
    func authViewControllerDidAuthenticate(_ viewController: AuthViewController)
    func authViewControllerDidCancel(_ viewController: AuthViewController)
    func authViewController(_ viewController: AuthViewController, didFailWith error: Error)
}

final class AuthViewController: UIViewController {
    
    // MARK: - IB Outlets
    @IBOutlet weak var loginButton: UIButton!
    
    // MARK: - Public Properties
    private let oauth2ServiceToken = OAuth2Service.shared
    weak var navigationDelegate: AuthNavigationDelegate?
    
    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackButton()
    }
    
    // MARK: - IB Actions
    @IBAction func loginButtonTapped() {
        navigationDelegate?.authViewControllerDidAuthenticate(self)
    }
    
    // MARK: - Public Methods
    func showAuthErrorAlert() {
        let alert = UIAlertController(title: "Что-то пошло не по плану", message: "Авторизация не удалась", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Private Methods
    private func configureBackButton() {
        navigationController?.navigationBar.backIndicatorImage = UIImage(resource: .navBackButton)
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(resource: .navBackButton)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor(resource: .ifBlack)
    }
    
    private func fetchOAuthToken(_ code: String, completion: @escaping(Result <String, Error>) -> Void) {
        oauth2ServiceToken.fetchOAuthToken(code: code) { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
}

// MARK: - WebViewViewControllerDelegate
extension  AuthViewController: WebViewViewControllerDelegate {
    
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        vc.dismiss(animated: true) { [weak self] in
            guard let self else { return }
            
            self.fetchOAuthToken(code) { result in
                DispatchQueue.main.async {
                    
                    switch result {
                    case .success(let token):
                        OAuth2TokenStorage.shared.token = token
                        self.navigationDelegate?.authViewControllerDidAuthenticate(self)
                        
                    case .failure(let error):
                        self.navigationDelegate?.authViewController(self, didFailWith: error)
                        print(error)
                    }
                }
            }
        }
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        vc.dismiss(animated: true)
        self.navigationDelegate?.authViewControllerDidCancel(self)
    }
}
