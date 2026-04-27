@testable import imageFeed
import Foundation

final class ProfilePresenterSpy: ProfilePresenterProtocol {
    
    weak var view: ProfileViewControllerProtocol?
    
    private(set) var viewDidLoadCalled = false
    private(set) var didTapLogoutCalled = false
    private(set) var didConfirmLogoutCalled = false
        
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func didTapLogout() {
        didTapLogoutCalled = true
        view?.showLogoutConfirmation()
    }
    
    func didConfirmLogout() {
        didConfirmLogoutCalled = true
        view?.showLogoutFlow()
    }
}
