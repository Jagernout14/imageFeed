@testable import imageFeed
import XCTest

final class ProfilePresenterSpy: ProfilePresenterProtocol {
    
    var view: ProfileViewControllerProtocol?
    
    var viewDidLoadCalled = false
    var didTapLogoutCalled = false
    var didConfirmLogoutCalled = false
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func didTapLogout() {
        didTapLogoutCalled = true
    }
    
    func didConfirmLogout() {
        didConfirmLogoutCalled = true
    }
}
