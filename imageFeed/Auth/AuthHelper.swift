import Foundation

//MARK: AuthHelperProtocol
protocol AuthHelperProtocol {
    var authURLRequest: URLRequest? { get }
    func getCode(from: URL) -> String?
}

final class AuthHelper: AuthHelperProtocol {
    
    // MARK: - Public Properties
    private let configuration: AuthConfiguration
    
    var authURL: URL? {
        guard var urlComponents = URLComponents(string: configuration.authURLString) else {
            return nil
        }
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: configuration.accessKey),
            URLQueryItem(name: "redirect_uri", value: configuration.redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: configuration.accessScope)
        ]
        
        return urlComponents.url
    }
    
    // MARK: - Private Properties
    var authURLRequest: URLRequest? {
        guard let url = authURL else { return nil }
        return URLRequest(url: url)
    }
    
    // MARK: - Initializers
    init(configuration: AuthConfiguration = .standard) {
        self.configuration = configuration
    }
    
    // MARK: - Public Methods
    func getCode(from url: URL) -> String? {
        
        let components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        
        if let code = components?.queryItems?
            .first(where: { $0.name == "code" })?
            .value {
            return code
        }
        
        if let fragment = url.fragment {
            return fragment
                .components(separatedBy: "&")
                .first(where: { $0.contains("code=") })?
                .replacingOccurrences(of: "code=", with: "")
        }
        
        return nil
    }
}
