import XCTest
@testable import imageFeed

final class ProfileViewControllerTests: XCTestCase {
    
    var viewController: ProfileViewController!
    var presenterSpy: ProfilePresenterSpy!
    
    override func setUp() {
        super.setUp()
        
        viewController = ProfileViewController()
        presenterSpy = ProfilePresenterSpy()
        
        viewController.presenter = presenterSpy
        
        viewController.loadViewIfNeeded()
    }
    
    override func tearDown() {
        viewController = nil
        presenterSpy = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    func testViewDidLoadCallsPresenter() {
        XCTAssertTrue(presenterSpy.viewDidLoadCalled)
    }
    
    func testShowLogoutConfirmationPresentsAlert() {
        let window = UIWindow()
        window.rootViewController = viewController
        window.makeKeyAndVisible()
        
        viewController.showLogoutConfirmation()
        
        let alert = viewController.presentedViewController as? UIAlertController
        XCTAssertNotNil(alert)
        XCTAssertEqual(alert?.title, "Пока, Пока!")
    }
    
    func testLogoutButtonTapCallsPresenter() {
        let button = viewController.view.subviews
            .compactMap { $0 as? UIButton }
            .first { $0.accessibilityIdentifier == AccessibilityIdentifiers.ProfileView.logoutButton }
        
        button?.sendActions(for: .touchUpInside)
        XCTAssertTrue(presenterSpy.didTapLogoutCalled)
    }
}
