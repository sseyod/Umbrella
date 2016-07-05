//
//  UMOpenWeather.swift
//  Umbrella
//
//  Created by Pete Cole on 19/11/2015.
//  Copyright © 2015 Pete Cole. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation

public class ForecastItem : NSObject {
  public override init() {
    super.init()
  }
  
  public var temperatureCentigrade = ""
  public var dateTimeString = ""
  public var weatherDescription = ""
}

public class UMOpenWeather {
  // OpenWeatherMap API key
  // Please do not share/abuse this key!
  private let cOpenWeatherKey = "18fee199474a3c3e916250163c923a29"
  
  let timeoutInterval = 10.0 // Query timeout in seconds
  
  public required init() {
  }
 
  //
  // MARK: Query control
  //
  public typealias  ForecastCompletionFunction = (result:Array<ForecastItem>, errorString:String?) -> ()
  private typealias OpenWeatherRequestCompletionFunction = (result:NSDictionary?, errorString:String?) -> ()
  
  private func convertQueriedDictionaryToForecastArray(result:NSDictionary) -> (Array<ForecastItem>, errorString:String?) {
    
    var forecastArray = Array<ForecastItem>()
    
    guard let arrayOfValues = result["list"] as? NSArray else {
      return(forecastArray, "Query failed!")
    }
    
    for item in arrayOfValues {
      guard let dict = item as? NSDictionary else {
        return(forecastArray, "Query failed!")
      }
      
      let forecastItem = ForecastItem()
      forecastArray.append(forecastItem)
      
      if let mainDict = dict["main"] as? NSDictionary {
        if let tempKelvin = mainDict["temp"] as? Double {
          let tempCentigrade = tempKelvin - 273.15
          let tempCentigradeString = String(format:"%0.1f °C", tempCentigrade)
          forecastItem.temperatureCentigrade = tempCentigradeString
        }
      }
      
      // If "clouds" or "wind" etc., we could display a headline set of imagery.
      
      if let dateTime = dict["dt_txt"] as? String {
        let items = dateTime.componentsSeparatedByString(" ")
        if (items.count >= 2) {
          forecastItem.dateTimeString = "\(items[0])\n\(items[1])"
        } else if (items.count == 1) {
          forecastItem.dateTimeString = "\(items[0])"
        }
      }
      
      guard let weatherArray = dict["weather"] as? NSArray else {
        return(forecastArray, "Query failed - no weather!")
      }
      
      for valueItem in weatherArray {
        
        let weatherDict = valueItem as! NSDictionary
        if let weatherDescription = weatherDict["description"] as? String {
          if (forecastItem.weatherDescription == "") {
            forecastItem.weatherDescription = weatherDescription
          } else {
            forecastItem.weatherDescription += ", \(weatherDescription)"
          }
        }
        
        // TODO: Could do more, for example to extract data that could be used to display a weather-related icon!
      }
    }
   
    // No error!
    return(forecastArray, nil)
  }
  
  /*
  Example query (weather forecast near London)
  
  Query data at lat/lon, several days...
  http://api.openweathermap.org/data/2.5/forecast?APPID=18fee199474a3c3e916250163c923a29&lat=51.5067288&lon=-0.16425
  
  Other queries...:
 
  Query data at lat/lon, 7 day:
  http://api.openweathermap.org/data/2.5/forecast/daily?APPID=18fee199474a3c3e916250163c923a29&lat=51.5067288&lon=-0.16425
  
  Query specific City - current weather.
  http://api.openweathermap.org/data/2.5/weather?APPID=18fee199474a3c3e916250163c923a29&q=London
  */
  
  public func queryLocalWeatherForToday(completion: ForecastCompletionFunction) {
    
    guard let location = getCurrentLocation() else {
      // handle if location NOT known!
      completion(result: Array<ForecastItem>(), errorString: "Location unknown!")
      return
    }
    
    queryWeatherForLocation(location, completion: { (result:NSDictionary?, errorString:String?) in
      if (errorString != nil) {
        completion(result:Array<ForecastItem>(), errorString:errorString)
        return
      }
      
      guard let theResult = result else {
        completion(result:Array<ForecastItem>(), errorString: "Query failed!")
        return
      }
     
      // Process the queried Dictionary, into an array of data points (i.e. the model)
      let forecastArray:Array<ForecastItem>
      var errorString:String?
      (forecastArray, errorString) = self.convertQueriedDictionaryToForecastArray(theResult)
      completion(result: forecastArray, errorString: errorString)
    })
  }

  private func getCurrentLocation() -> CLLocation? {
    let locationManager = CLLocationManager()
    let location = locationManager.location
    return location
  }
  
  private func queryWeatherForLocation(location:CLLocation, completion: OpenWeatherRequestCompletionFunction) {
  
    /// URL of the OpenWeatherMap API endpoint
    let queryUrl = "http://api.openweathermap.org/data/2.5/forecast?APPID=\(cOpenWeatherKey)&lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)"
    
    let request = NSMutableURLRequest(URL: NSURL(string:queryUrl)!)
    request.HTTPMethod = "GET"
    request.timeoutInterval = timeoutInterval
    request.setValue(cOpenWeatherKey, forHTTPHeaderField:"APPID")
    
    let session = NSURLSession.sharedSession()
    let task = session.dataTaskWithRequest(request) { (inData:NSData?, inResponse:NSURLResponse?, inError:NSError?) in
      if ((inResponse == nil) || (inData == nil)) {
        // Handle error!
        if (inError != nil) {
          completion(result:nil, errorString:"Error!")
        }
      } else {
        let httpResponse:NSHTTPURLResponse = inResponse as! NSHTTPURLResponse!
        
        if (httpResponse.statusCode != 200) {
          completion(result:nil, errorString:"Error!")
        } else {
          do {
          
            if let resultJsonAsDict = try NSJSONSerialization.JSONObjectWithData(inData!, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary {
              // Got it!
              completion(result: resultJsonAsDict, errorString:nil)
              return
            }
          } catch _ {
            completion(result:nil, errorString:"Error!")
            return
          }
         
          completion(result:nil, errorString:"Error!")
        }
      }
    }
    task.resume()
  }
}
