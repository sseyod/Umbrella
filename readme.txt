Notes
=====

Requirements
============

XCode 7.x and later
iOS Simulator

Instructions
============

1. Build and run the app! :)
2. Press the "Update" button in top right to redo the query, in case you've e.g. changed location since you started...
3. That's it!

Notes on what I've done
=======================

Registered with OpenMap ... http://openweathermap.org/appid
... got an API key, which is used by the app.

Read-up sufficient of the OpenMap API, to figure-out the URL required to query the data we want.
Looked at the output using a web browser, made it readable with JSON Editor app; to get a better
visual view of the format of the queried JSON data.

Created example project with XCode.

Modified Info.plist to:
- set CFBundleDisplayName, to allow me to customise the app title easily if I want to while prototyping
- set NSAppTransportSecurity (so queries can work properly in iOS 9)
- set to Portrait mode only for Phone (makes a quick app easier to lay-out properly on iPhone)
- set NSLocationAlwaysUsageDescription, as we need to use CoreLocation!

Added CoreLocation to the project.
Created UMLocationCapture class to capture the current location.

Wrote a simple OpenMap adaptor class.
Called this UMOpenWeather.swift
Implemented a method to return all weather data for the specified location, for the current day
and the next few days (separated by a few hours per data item).
Captured this data to an array of ForcecastItem values, which represents the data model.
Unit test to verify this works OK.

Decided to implement the main View Controller as UITableView to show the queried data.
Wrote code to query weather forcecast based on the current location.
Made sure that we handle the queried data on the main UI thread; and hooked this up to the Table
View.
Tested that this works OK.

Added a custom cell to the storyboard, used a custom cell class.
Made the Table View use this cell, and generally tidied-up the UI with a bit of colouring.

Created an Icon using Affinity Designer and Asset Catalog Creator.
Created a Splash background using Affinity Designer, Asset Catalog Creator and the storyboard
editor.

For each time slot of weather data returned, display a separate row in the table view.
Display Time, Temperature (in Celcius), and icon that is fixed (currently) and the description.
Used a very rough colour scheme just to make it look interesting (blue/yellow)
Added a handful of very simple unit tests.

Next steps
==========

Next steps, if I had time!
- Use nice icons for the weather, e.g. clouds/sun
- Display in Celcius or Farenheit, depending on Local preferences.
- Animations, e.g. drifting clouds!
- Display a summary for the first 24 hours, maybe in a panel at the top of the screen.
- Add HockeyApp or similar, Google Analytics or similar
- Consider using custom fonts, e.g. Lato
- Have some fun with icons using PaintCode
- Extend the tests
- Add UI tests ... e.g. http://www.mokacoding.com/blog/xcode-7-ui-testing/
