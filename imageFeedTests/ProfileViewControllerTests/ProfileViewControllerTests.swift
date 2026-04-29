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
    func test_viewDidLoad_callsPresenter() {
        XCTAssertTrue(presenterSpy.viewDidLoadCalled)
    }
    
    func test_showLogoutConfirmation_presentsAlert() {
        let window = UIWindow()
        window.rootViewController = viewController
        window.makeKeyAndVisible()
        
        viewController.showLogoutConfirmation()
        
        let alert = viewController.presentedViewController as? UIAlertController
        XCTAssertNotNil(alert)
        XCTAssertEqual(alert?.title, "Пока, Пока!")
    }
    
    func test_logoutButtonTap_callsPresenter() {
        let button = viewController.view.subviews
            .compactMap { $0 as? UIButton }
            .first { $0.accessibilityIdentifier == AccessibilityIdentifiers.ProfileView.logoutButton }
        
        button?.sendActions(for: .touchUpInside)
        XCTAssertTrue(presenterSpy.didTapLogoutCalled)
    }
}
