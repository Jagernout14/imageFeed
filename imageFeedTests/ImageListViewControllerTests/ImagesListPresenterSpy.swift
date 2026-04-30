import XCTest
@testable import imageFeed

final class ImagesListPresenterSpy: ImagesListPresenterProtocol {

    var photosCount: Int = 0
    var photoStub: Photo!

    private(set) var viewDidLoadCalled = false
    private(set) var willDisplayIndex: Int?
    private(set) var didTapLikeIndex: Int?

    func viewDidLoad() {
        viewDidLoadCalled = true
    }

    func photo(at index: Int) -> Photo {
        photoStub
    }

    func willDisplayCell(at index: Int) {
        willDisplayIndex = index
    }

    func didTapLike(at index: Int) {
        didTapLikeIndex = index
    }
}
