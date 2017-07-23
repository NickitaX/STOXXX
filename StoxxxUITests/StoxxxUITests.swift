//
//  StoxxxUITests.swift
//  StoxxxUITests
//
//  Created by Nickita on 7/5/17.
//  Copyright © 2017 Nickita. All rights reserved.
//

import XCTest

class StoxxxUITests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testMoreTab(){
        if XCUIApplication().tables.staticTexts["AAPL"].exists {
            let tablesQuery = XCUIApplication().tables
            tablesQuery.staticTexts["AAPL"].swipeLeft()
            tablesQuery.buttons["Delete"].tap()
        }
        
        XCUIApplication().buttons["+"].tap()
        let app = XCUIApplication()
        let enterYourStockHereTextField = app.textFields["Enter your stock here..."]
        enterYourStockHereTextField.tap()
        enterYourStockHereTextField.typeText("AAPL")
        app.buttons["Add"].tap()
        app.alerts["Success!"].buttons["OK"].tap()
        XCUIApplication().children(matching: .window).element(boundBy: 0).children(matching: .other).element(boundBy: 1).children(matching: .other).element(boundBy: 1).children(matching: .image).element(boundBy: 0).tap()
        
        
        let tablesQuery = XCUIApplication().tables
        tablesQuery.staticTexts["AAPL"].tap()
        XCUIApplication().tables.cells.allElementsBoundByIndex[Int(XCUIApplication().tables.cells.count - 1)].buttons["More"].tap()
        XCUIDevice.shared().orientation = .faceUp
        
        let app2 = XCUIApplication()
        XCTAssertTrue(app2.tables.staticTexts["\"Apple Inc.\""].exists)
        
    }
    
    func testUniverse(){
        if XCUIApplication().tables.staticTexts["AAPL"].exists {
            let tablesQuery = XCUIApplication().tables
            tablesQuery.staticTexts["AAPL"].swipeLeft()
            tablesQuery.buttons["Delete"].tap()
            
        }
        
        if XCUIApplication().tables.staticTexts["GOOGL"].exists {
            let tablesQuery = XCUIApplication().tables
            tablesQuery.staticTexts["GOOGL"].swipeLeft()
            tablesQuery.buttons["Delete"].tap()
            
        }
        XCUIApplication().buttons["+"].tap()
        let app = XCUIApplication()
        let enterYourStockHereTextField = app.textFields["Enter your stock here..."]
        enterYourStockHereTextField.tap()
        enterYourStockHereTextField.typeText("AAPL")
        app.buttons["Add"].tap()
        app.alerts["Success!"].buttons["OK"].tap()
        XCUIApplication().children(matching: .window).element(boundBy: 0).children(matching: .other).element(boundBy: 1).children(matching: .other).element(boundBy: 1).children(matching: .image).element(boundBy: 0).tap()
        
        XCUIApplication().buttons["+"].tap()
        let app2 = XCUIApplication()
        let enterYourStockHereTextField2 = app2.textFields["Enter your stock here..."]
        enterYourStockHereTextField2.tap()
        enterYourStockHereTextField2.typeText("GOOGL")
        app2.buttons["Add"].tap()
        XCUIApplication().children(matching: .window).element(boundBy: 0).children(matching: .other).element(boundBy: 1).children(matching: .other).element(boundBy: 1).children(matching: .image).element(boundBy: 0).tap()
        
        
        let app3 = XCUIApplication()
        app3.buttons["u"].tap()
        
        sleep(2)
    
        
//        XCTAssertTrue( XCUIApplication().textViews["GOOGL"].exists)
//        
//        XCTAssertTrue( XCUIApplication().textViews["AAPL"].exists)

      
        
        
    }
    
    func testAddStock() {
        
        sleep(2)
        
        if XCUIApplication().tables.staticTexts["AAPL"].exists {
            
            let tablesQuery = XCUIApplication().tables
            tablesQuery.staticTexts["AAPL"].swipeLeft()
            tablesQuery.buttons["Delete"].tap()
            
        }
        XCUIApplication().buttons["+"].tap()
        
        let app = XCUIApplication()
        let enterYourStockHereTextField = app.textFields["Enter your stock here..."]
        enterYourStockHereTextField.tap()
        enterYourStockHereTextField.typeText("AAPL")
        app.buttons["Add"].tap()
        app.alerts["Success!"].buttons["OK"].tap()
        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element(boundBy: 1).children(matching: .other).element(boundBy: 1).children(matching: .image).element(boundBy: 2).tap()
        
        XCTAssertTrue(XCUIApplication().tables.staticTexts["AAPL"].exists)
        
    }
    
    func testDeleteStock(){
        sleep(2)
        
        if XCUIApplication().tables.staticTexts["AAPL"].exists {
            
            let tablesQuery = XCUIApplication().tables
            tablesQuery.staticTexts["AAPL"].swipeLeft()
            tablesQuery.buttons["Delete"].tap()
            
        }
        XCUIApplication().buttons["+"].tap()
        
        let app = XCUIApplication()
        let enterYourStockHereTextField = app.textFields["Enter your stock here..."]
        enterYourStockHereTextField.tap()
        enterYourStockHereTextField.typeText("AAPL")
        app.buttons["Add"].tap()
        app.alerts["Success!"].buttons["OK"].tap()
        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element(boundBy: 1).children(matching: .other).element(boundBy: 1).children(matching: .image).element(boundBy: 2).tap()
        
        let tablesQuery = XCUIApplication().tables
        tablesQuery.staticTexts["AAPL"].swipeLeft()
        tablesQuery.buttons["Delete"].tap()
        
        XCTAssertFalse(XCUIApplication().tables.staticTexts["AAPL"].exists)
    }
    
}
