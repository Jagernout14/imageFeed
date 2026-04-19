import UIKit

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    var isLiked: Bool
}

struct PhotoResult: Codable {
    let id: String
    let width: Int
    let height: Int
    let createdAt: String?
    let description: String?
    let urls: UrlResults
    var isLiked: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case width
        case height
        case createdAt = "created_at"
        case description
        case urls
        case isLiked = "liked_by_user"
    }
}

struct UrlResults: Codable {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
}

final class ImagesListService {
    
    // MARK: - Public Properties
    static let shared = ImagesListService()
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    // MARK: - Private Properties
    private(set) var photos: [Photo] = []
    private var isLoading = false
    private var lastLoadedPage: Int?
    private let isoFormatter = ISO8601DateFormatter()
    
    
    // MARK: - Initializers
    private init() {}
    
    // MARK: - Public Methods
    func fetchPhotosNextPage() {
        if isLoading {
            return
        }
        isLoading = true
        let nextPage = (lastLoadedPage ?? 0) + 1
        guard let token = OAuth2TokenStorage.shared.token else {
            isLoading = false
            return
        }
        guard let request = makePhotosUrlRequest(page: nextPage, token: token) else {
            isLoading = false
            return
        }
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self else { return }
            switch result {
            case .success(let photoResults):
                let isoFormatter = self.isoFormatter
                let newPhotos = photoResults.map { result in
                    let date = result.createdAt.flatMap {
                        isoFormatter.date(from: $0)
                    }
                    return Photo(
                        id: result.id,
                        size: CGSize(width: result.width, height: result.height),
                        createdAt: date, // fix dat
                        welcomeDescription: result.description,
                        thumbImageURL: result.urls.thumb,
                        largeImageURL: result.urls.full,
                        isLiked: result.isLiked
                    )
                }
                DispatchQueue.main.async {
                    self.photos.append(contentsOf: newPhotos)
                    self.lastLoadedPage = nextPage
                    self.isLoading = false
                    
                    NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: self)
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    print("ImageListService: \(error.localizedDescription)")
                    self.isLoading = false
                }
            }
        }
        task.resume()
    }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        guard let token = OAuth2TokenStorage.shared.token else {
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        guard let url = URL(string: "https://api.unsplash.com/photos/\(photoId)/like") else {
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = isLike ? HTTPMethod.post.rawValue : HTTPMethod.delete.rawValue
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.data(for: request) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func updatePhotoLike(photoId: String) {
        if let index = photos.firstIndex(where: { $0.id == photoId }) {
            let photo = photos[index]
            
            let newPhoto = Photo(id: photo.id, size: photo.size, createdAt: photo.createdAt, welcomeDescription: photo.welcomeDescription, thumbImageURL: photo.thumbImageURL, largeImageURL: photo.largeImageURL, isLiked: !photo.isLiked)
            photos[index] = newPhoto
        }
    }
    
    func logoutImagesList() {
        photos = []
        isLoading = false
        lastLoadedPage = nil
    }
    
    // MARK: - Private Methods
    private func makePhotosUrlRequest(page: Int, token: String) -> URLRequest? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.unsplash.com"
        components.path = "/photos"
        components.queryItems = [
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "per_page", value: "10")
        ]
        
        guard let url = components.url else {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}

extension Array {
    func withReplaced(itemAt index: Int, newValue: Element) -> [Element] {
        var copy = self
        copy[index] = newValue
        return copy
    }
}
