//
//  UmbrellaTests.swift
//  UmbrellaTests
//
//  Created by Pete Cole on 19/11/2015.
//  Copyright © 2015 Pete Cole. All rights reserved.
//

import XCTest
@testable import Umbrella

class UmbrellaTests: XCTestCase {
  
  var vc : UMController!
  
  override func setUp() {
    super.setUp()
    
    let storyBoard:UIStoryboard? = UIStoryboard(name:"Main", bundle: nil)
    
    vc = storyBoard?.instantiateViewControllerWithIdentifier("UMController") as! UMController
    
    // Ensure that all delegates are set-up...
    vc!.loadView()
    vc!.viewDidLoad()
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  func testUMControllerInitialised() {
   
    // Normally, I would also check for outlets being not-nil - but there aren't any!
    XCTAssertNotNil(vc, "View Controller initialised")
   
    XCTAssert(vc.tableView.numberOfSections == 1)
  }
}
