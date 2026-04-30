@testable import imageFeed
import XCTest

final class ImagesListViewSpy: ImagesListViewProtocol {

    var reloadDataCalled = false
    var insertRowsCalled = false
    var insertedIndexPaths: [IndexPath] = []

    var showLoadingCalled = false
    var hideLoadingCalled = false
    var errorMessage: String?

    func reloadData() {
        reloadDataCalled = true
    }

    func insertRows(at indexPaths: [IndexPath]) {
        insertRowsCalled = true
        insertedIndexPaths = indexPaths
    }

    func showError(_ message: String) {
        errorMessage = message
    }

    func showLoading() {
        showLoadingCalled = true
    }

    func hideLoading() {
        hideLoadingCalled = true
    }
}
