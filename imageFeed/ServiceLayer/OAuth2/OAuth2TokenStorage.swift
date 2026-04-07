import Foundation
class OAuth2TokenStorage {
    
    // MARK: - Public Properties
    var token: String? {
        get {
            return userDefaults.string(forKey: tokenKey)
        }
        set {
            userDefaults.set(newValue, forKey: tokenKey)
            userDefaults.synchronize()
        }
    }
    
    // MARK: - Private Properties
    private let tokenKey = "oauth2_access_token"
    private let userDefaults = UserDefaults.standard
}
