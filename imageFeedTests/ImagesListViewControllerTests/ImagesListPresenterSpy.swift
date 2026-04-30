@testable import imageFeed
import XCTest

final class ImagesListPresenterSpy: ImagesListPresenterProtocol {
    func photo(at index: Int) -> imageFeed.Photo? {
        return nil
    }
    
    func willDisplayCell(at index: Int) {}
    
    func didTapLike(at index: Int) {}
    
    var photosCount: Int = 0

    weak var view: ImagesListViewProtocol?

    var viewDidLoadCalled = false
    var photoCalledIndex: Int?
    var willDisplayCalledIndex: Int?
    var didTapLikeIndex: Int?

    func viewDidLoad() {
        viewDidLoadCalled = true
    }
}
