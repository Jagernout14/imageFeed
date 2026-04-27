import UIKit
import ProgressHUD

final class AuthViewController: UIViewController {
    
    // MARK: - Public Properties
    let showWebViewSegueIdentifier = "ShowWebView"
    private let oauth2ServiceToken = OAuth2Service.shared
    weak var delegate: AuthViewControllerDelegate?
    
    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackButton()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showWebViewSegueIdentifier {
            guard
                let webViewViewController = segue.destination as? WebViewViewController
            else {
                assertionFailure("Failed to prepare for \(showWebViewSegueIdentifier)")
                return
            }
            let authHelper = AuthHelper()
            let webViewPresenter = WebViewPresenter(authHelper: authHelper)
            webViewViewController.presenter = webViewPresenter
            webViewPresenter.view = webViewViewController
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    // MARK: - Private Methods
    private func configureBackButton() {
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "nav_back_button")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "nav_back_button")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor(named: "IF_Black")
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
        vc.dismiss(animated: true)
        UIBlockingProgressHUD.show()
        
        fetchOAuthToken(code) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            guard let self else { return }
            
            switch result {
            case .success(let token):
                OAuth2TokenStorage.shared.token = token
                print("Успешная авторизация. Токен \(token)")
                self.delegate?.didAuthenticate(self)
                
            case .failure(let error):
                print("Не удалось авторизоваться. Ошибка \(error)")
                self.showAuthErrorAlert()
            }
        }
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        vc.dismiss(animated: true)
    }
}

extension AuthViewController {
    func showAuthErrorAlert() {
        let alert = UIAlertController(title: "Что-то пошло не по плану", message: "Авторизация не удалась", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
