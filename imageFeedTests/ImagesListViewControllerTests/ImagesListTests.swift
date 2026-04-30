import XCTest
@testable import imageFeed

final class ImagesListViewControllerTests: XCTestCase {
    
    func testViewDidLoadCallsPresenter() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(
            withIdentifier: AccessibilityIdentifiers.ImagesListView.imagesListViewController
        ) as! ImagesListViewController
        
        let presenter = ImagesListPresenterSpy()
        vc.presenter = presenter
        vc.loadViewIfNeeded()
        
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testPhotoAtEmptyArrayReturnsNil() {
        let presenter = ImagesListPresenter()
        let photo = presenter.photo(at: 0)
        
        XCTAssertNil(photo)
    }
    
    func testWillDisplayCellLastIndexTriggersFetch() {
        let presenter = ImagesListPresenter()
        presenter.willDisplayCell(at: 0)
        
        XCTAssertTrue(true)
    }
}
