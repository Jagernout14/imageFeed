@testable import imageFeed
import XCTest

final class WebViewTest: XCTestCase {
    
    func testViewControllerCallsViewDidLoad() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "WebViewViewController") as! WebViewViewController
        
        let presenter = WebViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        _ = viewController.view
        
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testPresenterCallsLoadRequest() {
        let view = WebViewViewControllerSpy()
        
        let authHelper = AuthHelperSpy()
        let url = URL(string: "https://example.com")!
        let request = URLRequest(url: url)
        authHelper.authRequestStub = request
        
        let presenter = WebViewPresenter(authHelper: authHelper)
        
        presenter.view = view
        view.presenter = presenter
        
        presenter.viewDidLoad()
        
        XCTAssertTrue(view.loadRequestCalled)
    }
}

