@testable import imageFeed
import Foundation

final class ImagesListPresenterSpy: ImagesListPresenterProtocol {
    
    weak var view: ImagesListViewProtocol?
    
    var photosCountStub: Int = 0
    var viewDidLoadCalled = false
    var photoCalledIndex: Int?
    var willDisplayIndex: Int?
    var didTapLikeCalled = false
    var photosCount: Int {
        photosCountStub
    }
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func photo(at index: Int) -> Photo {
        photoCalledIndex = index
        
        return Photo(
            id: "1",
            size: .init(width: 100, height: 100),
            createdAt: Date(),
            welcomeDescription: nil,
            thumbImageURL: "",
            largeImageURL: "",
            isLiked: false
        )
    }
    
    func willDisplayCell(at index: Int) {
        willDisplayIndex = index
    }
    
    func didTapLike(at index: Int) {
        didTapLikeCalled = true
    }
}
