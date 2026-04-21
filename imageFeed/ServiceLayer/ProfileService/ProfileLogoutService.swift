import Foundation
import WebKit

final class ProfileLogoutService {
    
    // MARK: - Public Properties
    static let shared = ProfileLogoutService()
    
    // MARK: - Initializers
    private init() {}
    
    // MARK: - Public Methods
    func logout() {
        ProfileService.shared.logoutProfile()
        OAuth2TokenStorage.shared.token = nil
        ImagesListService.shared.logoutImagesList()
        ProfileImageService.shared.logoutProfileImage()
        cleanCookies()
    }
    
    // MARK: - Private Methods
    private func cleanCookies() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
}
