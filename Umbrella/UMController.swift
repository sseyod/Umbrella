//
//  UMController.swift
//  Umbrella
//
//  Created by Pete Cole on 19/11/2015.
//  Copyright © 2015 Pete Cole. All rights reserved.
//

import UIKit
import CoreLocation

public class UMController: UITableViewController {
  
  public let cOpenWeather = UMOpenWeather()
  var locationCapture:UMLocationCapture? = nil
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    locationCapture = UMLocationCapture { (location:CLLocation) in
      self.onLocationChanged(location)
      // Stop monitoring once we have the first location
      self.locationCapture?.stopLocationCapture()
    }
  }
  
  public override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
   
    // Start with an empty table, with correct sized rows...
    tableView.reloadData()
    
    // Start monitoring location!
    // checkWeatherForLocation is called automatically when we get the location.
    locationCapture?.startLocationCapture()
  }
  
  public override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    
    // Stop monitoring location!
    locationCapture?.stopLocationCapture()
  }
 
  public func onLocationChanged(location:CLLocation) {
    queryWeatherForCurrentLocation(location)
  }
  
  func checkWeatherForLocation() {
    guard let location = locationCapture?.getLastKnownLocation() else {
      return
    }
    queryWeatherForCurrentLocation(location)
  }
 
  //
  // MARK: The array of most recent weather forcecast results!
  //
  var mWeatherForecastArray = Array<ForecastItem>()
  
  func updateWeatherForecastArray(arrayOfValues:Array<ForecastItem>) {
    mWeatherForecastArray = arrayOfValues
    tableView.reloadData()
  }
  
  func queryWeatherForCurrentLocation (location:CLLocation) {
    
    cOpenWeather.queryLocalWeatherForToday() { (result:Array<ForecastItem>, errorString:String?) -> () in
      
      // We handle the results on the UI thread...
      dispatch_async(dispatch_get_main_queue(), { () -> Void in
        self.updateWeatherForecastArray(result)
      })
    }
  }
  
  
  //
  // MARK: UITableViewController
  //
  public override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return mWeatherForecastArray.count
  }
  
  public override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    // TODO - for now, I'm assuming this weather is sorted by date time!
    let cell = tableView.dequeueReusableCellWithIdentifier("UMTimedForecastCell", forIndexPath: indexPath) as! UMTimedForecastCell
   
    cell.timeLabel.text = ""
    // TODO - override icon, depending on weather! cell.weatherIcon.image = nil
    cell.temperatureLabel.text = ""
    
    // A rought illustration of using colours to help distinguish the rows
    cell.backgroundColor = (indexPath.row % 2 == 0) ? UIColor.whiteColor() : UIColor.yellowColor()

    let forecastItem = mWeatherForecastArray[indexPath.row]
    
    cell.temperatureLabel.text = forecastItem.temperatureCentigrade
    cell.timeLabel.text = forecastItem.dateTimeString
    cell.weatherDescription.text = forecastItem.weatherDescription
    
    // TODO - use an ICON!
    
    return cell
  }
 
  public override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 60.0
  }


  //
  // MARK: Outlets and actions
  //
  
  
  @IBAction func retryButton(sender: AnyObject) {
    checkWeatherForLocation()
  }
}

