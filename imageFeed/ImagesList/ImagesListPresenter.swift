import UIKit

protocol ImagesListPresenterProtocol: AnyObject {
    
    var photosCount: Int { get }
    
    func viewDidLoad()
    func photo(at index: Int) -> Photo
    func willDisplayCell(at index: Int)
    func didTapLike(at index: Int)
}

final class ImagesListPresenter: ImagesListPresenterProtocol {
    
    // MARK: - Public Properties
    weak var view: ImagesListViewProtocol?
    var photosCount: Int {
        photos.count
    }
    
    // MARK: - Private Properties
    private let service: ImagesListService
    private var photos: [Photo] = []
    
    // MARK: - Initializers
    init(service: ImagesListService = .shared) {
        self.service = service
    }
    
    // MARK: - Public Methods
    func photo(at index: Int) -> Photo {
        photos[index]
    }
    
    func viewDidLoad() {
        NotificationCenter.default.addObserver(forName: ImagesListService.didChangeNotification, object: nil,queue: .main) { [weak self] _ in
            self?.didUpdatePhotos()
        }
        service.fetchPhotosNextPage()
    }
    
    func willDisplayCell(at index: Int) {
        if index == photos.count - 1 {
            service.fetchPhotosNextPage()
        }
    }
    
    func didTapLike(at index: Int) {
        view?.showLoading()
        let photo = photos[index]
        
        service.changeLike(photoId: photo.id, isLike: !photo.isLiked) { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }
                self.view?.hideLoading()
                
                switch result {
                case .success:
                    if let index = self.photos.firstIndex(where: { $0.id == photo.id }) {
                        self.photos[index] = photo.toggleLike()
                        self.view?.reloadData()
                    }
                    
                case .failure:
                    self.view?.showError("Что-то пошло не так")
                }
            }
        }
    }
    
    // MARK: - Private Methods
    private func didUpdatePhotos() {
        let oldCount = photos.count
        let newPhotos = service.photos
        photos = newPhotos
        
        if oldCount == 0 {
            view?.reloadData()
        } else {
            let indexPaths = (oldCount..<newPhotos.count).map {
                IndexPath(row: $0, section: 0)
            }
            view?.insertRows(at: indexPaths)
        }
    }
}
