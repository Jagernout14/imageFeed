@testable import imageFeed
import XCTest
import WebKit

final class WebViewPresenterSpy: WebViewPresenterProtocol {
    
    var view: WebViewViewControllerProtocol?
    
    var viewDidLoadCalled = false
    var didUpdateProgressValueCalled = false
    var receivedProgress: Double?
    var codeToReturn: String?
    var receivedURL: URL?
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
        didUpdateProgressValueCalled = true
        receivedProgress = newValue
    }
    
    func code(from url: URL) -> String? {
        receivedURL = url
        return codeToReturn
    }
}
