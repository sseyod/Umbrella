//
//  UmbrellaTests.swift
//  UmbrellaTests
//
//  Created by Pete Cole on 19/11/2015.
//  Copyright © 2015 Pete Cole. All rights reserved.
//

import XCTest
@testable import Umbrella

class UMOpenWeatherTests: XCTestCase {
  
  override func setUp() {
    super.setUp()
  }
  
  override func tearDown() {
    super.tearDown()
  }
  
  func testOpenWeatherQuery() {
    let expectation = expectationWithDescription("Got result")
    var gotResult = Array<ForecastItem>()
    var gotErrorString:String? = nil
    
    let openWeather = UMOpenWeather()
    openWeather.queryLocalWeatherForToday() { (result:Array<ForecastItem>, errorString:String?) -> () in
      gotResult = result
      gotErrorString = errorString
      expectation.fulfill()
    }
    
    waitForExpectationsWithTimeout(4.0) { (NSError) -> Void in
      XCTAssert(gotResult.count > 0)
      XCTAssert(gotErrorString == nil)
      
      for item in gotResult {
        XCTAssert(item.dateTimeString != "")
        XCTAssert(item.temperatureCentigrade != "")
        XCTAssert(item.weatherDescription != "")
      }
    }
  }
}
