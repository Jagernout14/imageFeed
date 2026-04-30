import UIKit

protocol ImagesListPresenterProtocol: AnyObject {
    var photosCount: Int { get }
    var view: ImagesListViewProtocol? { get set }
    func viewDidLoad()
    func photo(at index: Int) -> Photo?
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
    private let service = ImagesListService.shared
    private var photos: [Photo] = []
    private var isLoading = false
    
    // MARK: - Public Methods
    func photo(at index: Int) -> Photo? {
        guard index >= 0, index < photos.count else {
            return nil
        }
        return photos[index]
    }
    
    func viewDidLoad() {
        NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.didUpdatePhotos()
        }
        fetchNextPageIfNeeded()
    }
    
    func willDisplayCell(at index: Int) {
        if index == photos.count - 1 {
            fetchNextPageIfNeeded()
        }
    }
    
    func didTapLike(at index: Int) {
        guard let photo = photo(at: index) else { return }
        
        view?.showLoading()
        isLoading = true
        
        service.changeLike(photoId: photo.id, isLike: !photo.isLiked) { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }
                self.isLoading = false
                self.view?.hideLoading()
                
                switch result {
                case .success:
                    self.updatePhotoLike(photoId: photo.id)
                case .failure:
                    self.view?.showError("Что-то пошло не так")
                }
            }
        }
    }
    
    // MARK: - Private Methods
    private func fetchNextPageIfNeeded() {
        guard !isLoading, !service.isLoading else { return }
        service.fetchPhotosNextPage()
    }
    
    private func didUpdatePhotos() {
        let oldCount = photos.count
        let newPhotos = service.photos
        photos = newPhotos
        
        if oldCount == 0 {
            view?.reloadData()
        } else if newPhotos.count > oldCount {
            let newCount = newPhotos.count
            let indexPaths = (oldCount..<newCount).map {
                IndexPath(row: $0, section: 0)
            }
            view?.insertRows(at: indexPaths)
        } else {
            view?.reloadData()
        }
    }
    
    private func updatePhotoLike(photoId: String) {
        if let index = photos.firstIndex(where: { $0.id == photoId }) {
            photos[index] = photos[index].toggleLike()
            view?.reloadData()
        }
    }
}
