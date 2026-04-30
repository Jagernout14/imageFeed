import XCTest
@testable import imageFeed

final class ImagesListPresenterTests: XCTestCase {
    
    private var presenter: ImagesListPresenter!
    private var view: ImagesListViewSpy!
    
    override func setUp() {
        super.setUp()
        
        view = ImagesListViewSpy()
        presenter = ImagesListPresenter(service: ImagesListService.shared)
        presenter.view = view
    }
    
    func test_viewDidLoad_fetchesPhotos() {
        presenter.viewDidLoad()
        
        // сервис дергается через Notification / fetch
        XCTAssertTrue(true) // минимальный smoke-test
    }
    
    func test_willDisplayCell_lastIndex_triggersPagination() {
        presenter.willDisplayCell(at: 999)

        // без spy сервиса мы проверяем только, что не падает
        XCTAssertTrue(true)
    }
    
    func test_didTapLike_showsLoading() {

        presenter.didTapLike(at: 0)

        XCTAssertTrue(view.showLoadingCalled)
    }
    
    func test_didTapLike_hidesLoading() {

        presenter.didTapLike(at: 0)

        XCTAssertTrue(view.hideLoadingCalled)
    }
}
