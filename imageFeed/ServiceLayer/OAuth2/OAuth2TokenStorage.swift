import Foundation
import SwiftKeychainWrapper
class OAuth2TokenStorage {
    
    // MARK: - Public Properties
    static let shared = OAuth2TokenStorage()
    private init() {}
    
    private let tokenKey = "token"
    
    var token: String? {
        get {
            KeychainWrapper.standard.string(forKey: tokenKey)
        }
        set {
            if let token = newValue {
                KeychainWrapper.standard.set(token, forKey: tokenKey)
            } else {
                KeychainWrapper.standard.removeObject(forKey: tokenKey)
            }
        }
    }
}
