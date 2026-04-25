import imageFeed
import Foundation

final class WebViewViewControllerSpy: WebViewViewControllerProtocol {
    
    var presenter: imageFeed.WebViewPresenterProtocol?
    var loadRequestCalled = false
    var receivedRequest: URLRequest?
    
    func setProgressValue(_ newValue: Float) {
    }
    func setProgressHidden(_ isHidden: Bool) {
    }
    
    func load(request: URLRequest) {
        loadRequestCalled = true
        receivedRequest = request
    }
}
