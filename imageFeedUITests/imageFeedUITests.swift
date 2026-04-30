
import XCTest

final class imageFeedUITests: XCTestCase {
    
    private let app = XCUIApplication()


    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }
    
    func testAuth() throws {
        print("💥💥💥Starting authentication test")
            app.buttons["Authenticate"].tap()
            print("💥💥💥Authenticate button tapped")
        print(app.debugDescription)

            
        let webView = app.webViews.firstMatch
        XCTAssertTrue(webView.waitForExistence(timeout: 10))
            XCTAssertTrue(webView.waitForExistence(timeout: 10), "Web view didn't appear")
            print("💥💥💥Web view appeared")

        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 5))
        
        loginTextField.tap()
        loginTextField.typeText("jagernout@icloud.com")
        webView.swipeUp()
        
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))
        
        passwordTextField.tap()
        passwordTextField.typeText("12341234")
        webView.swipeUp()
        
        webView.buttons["Login"].tap()
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
    }
    
    
    func testFeed() throws {
        let tablesQuery = app.tables
        
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        cell.swipeUp()
        
        sleep(2)
        
        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 1)
        
        let likeButton = cellToLike.descendants(matching: .button)["likeButton"]
        XCTAssertTrue(likeButton.waitForExistence(timeout: 5))
        likeButton.tap()
        
        sleep(2)
        
        cellToLike.tap()
        
        sleep(2)
        
        let image = app.scrollViews.images.element(boundBy: 0)
        image.pinch(withScale: 3, velocity: 1)
        image.pinch(withScale: 0.5, velocity: -1)
        
        let navBackButtonWhiteButton = app.buttons["backButton"]
            navBackButtonWhiteButton.tap()
    }
    
    func testProfile() throws {
        sleep(3)
        app.tabBars.buttons.element(boundBy: 1).tap()
       
        XCTAssertTrue(app.staticTexts["userName.name"].exists)
        XCTAssertTrue(app.staticTexts["loginName"].exists)
        
        app.buttons["logoutButton"].tap()
        
        let alert = app.alerts["Пока, Пока!"]
        XCTAssertTrue(alert.waitForExistence(timeout: 2))
        alert.buttons["Да"].tap()
    }
    
}

