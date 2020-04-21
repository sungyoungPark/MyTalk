//
//  MyTalkUITests.swift
//  MyTalkUITests
//
//  Created by 박성영 on 20/04/2020.
//  Copyright © 2020 박성영. All rights reserved.
//

import XCTest

class MyTalkUITests: XCTestCase {
    
    override func setUp() {
        
        continueAfterFailure = false
   
    }

    
    
    func testExample() {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testMyTalk(){
        
        let app = XCUIApplication()
        app.launch()
        app.textFields["Email"].tap()
        app.textFields["Email"].typeText("test1@test1.com")
        
       // app.secureTextFields["password"].tap()
        UIPasteboard.general.string = "test11"
        app.secureTextFields["password"].doubleTap()
        app.menuItems.element(boundBy: 0).tap()
        app.buttons["로그인"].tap()
        
     
      
               
    }
    
    

//    func testLaunchPerformance() {
//        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
//            // This measures how long it takes to launch your application.
//            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
//                XCUIApplication().launch()
//            }
//        }
//    }
}
