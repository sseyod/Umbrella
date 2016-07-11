//
//  UMLocationCapture.swift
//  Umbrella
//
//  Created by Pete Cole on 05/07/2016.
//  Copyright © 2016 Pete Cole. All rights reserved.
//

import UIKit
import CoreLocation

public class UMLocationCapture: NSObject, CLLocationManagerDelegate {
  
  public typealias tCallOnLocationChanged = (location:CLLocation) -> Void
  
  let locationManager = CLLocationManager()
  
  var mCallOnLocationChanged:tCallOnLocationChanged? = nil
  
  public init(callOnLocationChanged:tCallOnLocationChanged) {
    super.init()
    
    mCallOnLocationChanged = callOnLocationChanged
    locationManager.requestWhenInUseAuthorization()
  }

  private var mLastLocation:CLLocation? = nil
  
  func startLocationCapture() {
    locationManager.delegate = self
    locationManager.startUpdatingLocation()
    mLastLocation = locationManager.location
  }
  
  public func stopLocationCapture() {
    locationManager.delegate = nil
    locationManager.stopUpdatingLocation()
  }
  
  public func getLastKnownLocation() -> CLLocation? {
    return mLastLocation
  }

  public func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
    
    mLastLocation = newLocation
    
    if let callback = mCallOnLocationChanged {
      callback(location:newLocation)
    }
  }
}
