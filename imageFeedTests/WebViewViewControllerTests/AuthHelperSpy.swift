@testable import imageFeed
import XCTest

final class AuthHelperSpy: AuthHelperProtocol {
    
    var authURLRequest: URLRequest?
    
    var getCodeCalled = false
    var receivedURL: URL?
    var codeToReturn: String?
    
    func getCode(from url: URL) -> String? {
        getCodeCalled = true
        receivedURL = url
        return codeToReturn
    }
}
