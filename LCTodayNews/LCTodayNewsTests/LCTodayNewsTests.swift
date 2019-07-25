//
//  LCTodayNewsTests.swift
//  LCTodayNewsTests
//
//  Created by 罗超 on 2018/10/12.
//  Copyright © 2018年 罗超. All rights reserved.
//

import XCTest

class LCTodayNewsTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        let view = UIView()
        view.bounds = CGRect(x: 0, y: 0, width: 100, height: 100)
        view.backgroundColor = .red
        view.alpha = 0.5
        view.layer.bounds = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
