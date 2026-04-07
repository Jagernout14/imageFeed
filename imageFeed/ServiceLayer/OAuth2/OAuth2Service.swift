import Foundation

enum AuthServiceError: Error {
    case invalidRequest
}

final class OAuth2Service {
    
    // MARK: - Public Properties
    static let shared = OAuth2Service()
    
    // MARK: - Private Properties
    private let tokenStorage = OAuth2TokenStorage()
    private let urlSession = URLSession.shared
    
    private var task: URLSessionTask?
    private var lastCode: String?
    
    private(set) var authToken: String? {
        get {
            return tokenStorage.token
        }
        set {
            tokenStorage.token = newValue
        }
    }
    
    // MARK: - Initializers
    private init() {}
    
    // MARK: - Public Methods
    func fetchOAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        guard lastCode != code else {
            completion(.failure(AuthServiceError.invalidRequest))
            return
        }
        task?.cancel()
        lastCode = code
        guard let request = makeOAuthTokenRequest(code: code)
        else {
            completion(.failure(AuthServiceError.invalidRequest))
            return
        }
        
        let task = urlSession.data(for: request) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    do {
                        let decoder = JSONDecoder()
                        let tokenResponse = try decoder.decode(OAuthTokenResponseBody.self, from: data)
                        self?.tokenStorage.token = tokenResponse.accessToken
                        print("Получен и сохранен токен \(tokenResponse.accessToken)")
                        completion(.success(tokenResponse.accessToken))
                    } catch {
                        print("Ошибка декодирования ответа \(error)")
                        completion(.failure(NetworkError.decodingError(error)))
                    }
                    
                case .failure(let error):
                    switch error {
                    case NetworkError.httpStatusCode(let statusCode):
                        print("НТТР ошибка от Unsplash \(statusCode)")
                    case NetworkError.urlRequestError(let urlError):
                        print("Ошибка сети \(urlError)")
                    case NetworkError.urlSessionError:
                        print("Ошибка сессии URLSession")
                    default:
                        print("Неизвестная ошибка")
                    }
                    
                    completion(.failure(error))
                }
            }
            self?.task = nil
            self?.lastCode = nil
        }
        self.task = task
        task.resume()
    }
}

// MARK: - Private Methods
private func makeOAuthTokenRequest(code: String) -> URLRequest? {
    guard var urlComponents = URLComponents(string: "https://unsplash.com/oauth/token") else {
        return nil
    }
    
    urlComponents.queryItems = [
        URLQueryItem(name: "client_id", value: Constants.accessKey),
        URLQueryItem(name: "client_secret", value: Constants.secretKey),
        URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
        URLQueryItem(name: "code", value: code),
        URLQueryItem(name: "grant_type", value: "authorization_code")
    ]
    
    guard let authTokenUrl = urlComponents.url else {
        return nil
    }
    
    var request = URLRequest(url: authTokenUrl)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    
    return request
}
