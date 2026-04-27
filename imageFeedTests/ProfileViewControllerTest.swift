@testable import imageFeed
import XCTest

final class ProfileImageViewControllerTest: XCTestCase {
        
    
    func testViewControllerCallsViewDidLoad() {
        let viewController = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        viewController.loadViewIfNeeded()
        
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testLogoutTapCallsPresenter() {
        let viewController = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        viewController.loadViewIfNeeded()
        viewController.perform(Selector(("didTapLogoutButton")))
        
        XCTAssertTrue(presenter.didTapLogoutCalled)
    }
    
    func testShowAlertWhenLogout() {
        let viewController = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        viewController.loadViewIfNeeded()
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = viewController
        window.makeKeyAndVisible()
        viewController.showLogoutConfirmation()
        
        let alert = viewController.presentedViewController as? UIAlertController
        XCTAssertNotNil(alert)
        XCTAssertEqual(alert?.title, "Пока, Пока!")
    }
    
}
