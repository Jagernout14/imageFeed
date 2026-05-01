
import XCTest

final class imageFeedUITests: XCTestCase {
    
    private let app = XCUIApplication()
    
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }
    
    func testAuth() throws {
        app.buttons["Authenticate"].tap()
        print(app.debugDescription)
        sleep(3)
        
        
        let webView = app.webViews.firstMatch
        sleep(3)
        XCTAssertTrue(webView.waitForExistence(timeout: 10))
        XCTAssertTrue(webView.waitForExistence(timeout: 10), "Web view didn't appear")
        
        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 5))
        
        loginTextField.tap()
        loginTextField.typeText("jagernout@icloud.com")
        sleep(1)
        app.toolbars.buttons["Done"].tap()
        
        webView.swipeUp()
        
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))
        
        passwordTextField.tap()
        passwordTextField.typeText("12341234")
        webView.swipeUp()
        
        webView.buttons["Login"].tap()
        
        sleep(1)
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        
        XCTAssertTrue(cell.waitForExistence(timeout: 10))
    }
    
    
    func testFeedFlow() throws {
        let app = XCUIApplication()
        app.launch()
        
        let table = app.tables.firstMatch
        XCTAssertTrue(table.waitForExistence(timeout: 10))
        RunLoop.current.run(until: Date(timeIntervalSinceNow: 1))
        table.swipeUp()
        
        RunLoop.current.run(until: Date(timeIntervalSinceNow: 1))
        
        let cell = table.cells.firstMatch
        XCTAssertTrue(cell.waitForExistence(timeout: 10))
        let likeButton = cell.buttons.matching(identifier: "likeButton").firstMatch
        XCTAssertTrue(likeButton.waitForExistence(timeout: 5))
        
        likeButton.tap()
        
        RunLoop.current.run(until: Date(timeIntervalSinceNow: 1))
        
        let cellAgain = table.cells.firstMatch
        XCTAssertTrue(cellAgain.waitForExistence(timeout: 5))
        let likeButtonAgain = cellAgain.buttons.matching(identifier: "likeButton").firstMatch
        XCTAssertTrue(likeButtonAgain.waitForExistence(timeout: 5))
        likeButtonAgain.tap()
        
        cellAgain.tap()
        
        let image = app.images.firstMatch
        XCTAssertTrue(image.waitForExistence(timeout: 10))
        
        image.pinch(withScale: 2.0, velocity: 1.0)
        
        image.pinch(withScale: 0.5, velocity: -1.0)
        
        let backButton = app.buttons.firstMatch
        XCTAssertTrue(backButton.waitForExistence(timeout: 5))
        backButton.tap()
        XCTAssertTrue(table.waitForExistence(timeout: 5))
    }
    
    func testProfile() throws {
        sleep(3)
        app.tabBars.buttons.element(boundBy: 1).tap()
        sleep(1)
        
        XCTAssertTrue(app.staticTexts["userName.name"].exists)
        XCTAssertTrue(app.staticTexts["loginName"].exists)
        
        app.buttons["logoutButton"].tap()
        
        let alert = app.alerts["Пока, Пока!"]
        XCTAssertTrue(alert.waitForExistence(timeout: 2))
        alert.buttons["Да"].tap()
        
        let loginButton = app.buttons["Authenticate"]
        
        XCTAssertTrue(
            loginButton.waitForExistence(timeout: 5)
        )
    }
    
}

