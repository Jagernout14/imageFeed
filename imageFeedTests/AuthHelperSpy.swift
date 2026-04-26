@testable import imageFeed
import Foundation

final class AuthHelperSpy: AuthHelperProtocol {
    
    var authRequestStub: URLRequest?
    func authRequest() -> URLRequest? {
        return authRequestStub
    }
    func code(from url: URL) -> String? {
        return nil
    }
}
