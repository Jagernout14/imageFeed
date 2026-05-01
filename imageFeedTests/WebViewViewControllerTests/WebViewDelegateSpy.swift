@testable import imageFeed
import XCTest
import WebKit

final class WebViewDelegateSpy: WebViewViewControllerDelegate {
    
    var didAuthenticateCalled = false
    var receivedCode: String?
    
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        didAuthenticateCalled = true
        receivedCode = code
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {}
}
