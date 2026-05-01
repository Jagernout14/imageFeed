import Foundation

enum Constants {
    static let accessKey = "VxTFN82i8eeSsMyr46Ov9tw2NF5YUAmd-I3uWBn4NlI"
    static let secretKey = "06O9NxdKvA52I88vMVcJUFv1gtBi5dvIHIc6mcW9-HA"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    
    static let defaultBaseURLString: String = "https://api.unsplash.com/"
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
}

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURLString: String
    let authURLString: String
    
    static var standard: AuthConfiguration {
        AuthConfiguration(accessKey: Constants.accessKey,
                          secretKey: Constants.secretKey,
                          redirectURI: Constants.redirectURI,
                          accessScope: Constants.accessScope,
                          defaultBaseURLString: Constants.defaultBaseURLString,
                          authURLString: Constants.unsplashAuthorizeURLString
        )
    }
}
