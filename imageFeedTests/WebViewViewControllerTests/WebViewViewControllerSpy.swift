@testable import imageFeed
import XCTest

final class WebViewViewControllerSpy: WebViewViewControllerProtocol {
    
    var presenter: WebViewPresenterProtocol?
    
    var loadRequestCalled = false
    var receivedRequest: URLRequest?
    
    var setProgressCalled = false
    var progress: Float?
    
    var setHiddenCalled = false
    var isHidden: Bool?
    
    func load(request: URLRequest) {
        loadRequestCalled = true
        receivedRequest = request
    }
    
    func setProgressValue(_ newValue: Float) {
        setProgressCalled = true
        progress = newValue
    }
    
    func setProgressHidden(_ isHidden: Bool) {
        setHiddenCalled = true
        self.isHidden = isHidden
    }
}
