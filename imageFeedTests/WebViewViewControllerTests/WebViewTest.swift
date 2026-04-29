@testable import imageFeed
import XCTest
import WebKit

final class WebViewViewControllerTests: XCTestCase {
    
    var vc: WebViewViewController!
    var presenter: WebViewPresenterSpy!
    var delegate: WebViewDelegateSpy!
    
    override func setUp() {
        super.setUp()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        vc = storyboard.instantiateViewController(
            withIdentifier: "WebViewViewController"
        ) as? WebViewViewController
        
        presenter = WebViewPresenterSpy()
        delegate = WebViewDelegateSpy()
        
        vc.loadViewIfNeeded()
        
        vc.presenter = presenter
        presenter.view = vc
        vc.delegate = delegate
    }
    
    func testPresenterCallsLoadRequest() {
        let view = WebViewViewControllerSpy()
        let authHelper = AuthHelperSpy()
        let presenter = WebViewPresenter(authHelper: authHelper)
        
        presenter.view = view
        
        let request = URLRequest(url: URL(string: "https://apple.com")!)
        authHelper.authURLRequest = request
        
        presenter.viewDidLoad()
        
        XCTAssertTrue(view.loadRequestCalled)
        XCTAssertEqual(view.receivedRequest?.url, request.url)
    }
    
    func testProgressHiddenWhenOne() {
        let presenter = WebViewPresenter(authHelper: AuthHelperSpy())
        let view = WebViewViewControllerSpy()
        
        presenter.view = view
        
        presenter.didUpdateProgressValue(1.0)
        
        XCTAssertTrue(view.setHiddenCalled)
        XCTAssertEqual(view.isHidden, true)
    }
    
    func testProgressNotHiddenWhenLessThanOne() {
        let presenter = WebViewPresenter(authHelper: AuthHelperSpy())
        let view = WebViewViewControllerSpy()
        
        presenter.view = view
        
        presenter.didUpdateProgressValue(0.5)
        
        XCTAssertEqual(view.isHidden, false)
    }
    
    func testCodeFromURL() {
        let authHelper = AuthHelper()
        
        let url = URL(string: "https://upyachka.ru/oauth/authorize/native?code=12345")!
        
        let code = authHelper.getCode(from: url)
        
        XCTAssertEqual(code, "12345")
    }
    
}
