import XCTest
@testable import imageFeed

final class ImagesListViewSpy: ImagesListViewProtocol {

    var reloadDataCalled = false
    var insertRowsCalled = false
    var showErrorCalled = false
    var showLoadingCalled = false
    var hideLoadingCalled = false

    func reloadData() {
        reloadDataCalled = true
    }

    func insertRows(at indexPaths: [IndexPath]) {
        insertRowsCalled = true
    }

    func showError(_ message: String) {
        showErrorCalled = true
    }

    func showLoading() {
        showLoadingCalled = true
    }

    func hideLoading() {
        hideLoadingCalled = true
    }
}
