import imageFeed
import Foundation

final class WebViewViewControllerSpy: WebViewViewControllerProtocol {
    
    var presenter: imageFeed.WebViewPresenterProtocol?
    var loadRequestCalled = false
    
    func setProgressValue(_ newValue: Float) {
    }
    func setProgressHidden(_ isHidden: Bool) {
    }
    
    func load(request: URLRequest) {
        loadRequestCalled = true
    }
}
