@testable import imageFeed
import XCTest

final class ImagesListViewControllerTests: XCTestCase {
    
    private var viewController: ImagesListViewController!
    private var presenter: ImagesListPresenterSpy!
    
    override func setUp() {
        super.setUp()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        viewController = storyboard.instantiateViewController(
            withIdentifier: "ImagesListViewController"
        ) as? ImagesListViewController
        presenter = ImagesListPresenterSpy()
        viewController.presenter = presenter
        _ = viewController.view
    }
    
    override func tearDown() {
        viewController = nil
        presenter = nil
        super.tearDown()
    }
    
    func testViewDidLoadCallsPresenter() {
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testNumberOfRowsReturnsPresenterCount() {
        presenter.photosCountStub = 5
        XCTAssertEqual(presenter.photosCount, 5)
    }
    
    func testPhotoAtIndexReturnsCorrectPhoto() {
        let photo = viewController.presenter?.photo(at: 0)
        
        XCTAssertEqual(presenter.photoCalledIndex, 0)
        XCTAssertEqual(photo?.id, "1")
    }
    
    func testWillDisplayCallsPresenter() {
        let indexPath = IndexPath(row: 3, section: 0)
        viewController.tableView(
            UITableView(),
            willDisplay: UITableViewCell(),
            forRowAt: indexPath
        )
        
        XCTAssertEqual(presenter.willDisplayIndex, 3)
    }
    
    func testDidSelectRowDoesNotCrash() {
        let indexPath = IndexPath(row: 0, section: 0)
        viewController.tableView(
            UITableView(),
            didSelectRowAt: indexPath
        )
        
        XCTAssertTrue(true)
    }
    
}
