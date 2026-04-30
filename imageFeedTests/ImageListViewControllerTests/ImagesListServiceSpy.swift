import XCTest
@testable import imageFeed

final class ImagesListServiceSpy {

    var fetchNextPageCalled = false
    var changeLikeCalled = false

    var photos: [Photo] = []

    func fetchPhotosNextPage() {
        fetchNextPageCalled = true
    }

    func changeLike(photoId: String,
                    isLike: Bool,
                    _ completion: @escaping (Result<Void, Error>) -> Void) {
        changeLikeCalled = true
        completion(.success(()))
    }
}
