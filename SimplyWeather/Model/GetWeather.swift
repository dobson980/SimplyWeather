//
//  File.swift
//  SimplyWeather
//
//  Created by Tom Dobson on 8/22/17.
//  Copyright © 2017 Dobson Studios. All rights reserved.
//

import Foundation

// Google Key AIzaSyAJV4effU8Q9WD0fgfykVJ1q7yWATsxDfY

// http://api.wunderground.com/api/50e8ac2d75f2762e/geolookup/q/32.7157,.json

//http://api.wunderground.com/api/50e8ac2d75f2762e/geolookup/forecast/q/

//http://api.wunderground.com/api/50e8ac2d75f2762e/conditions/q/

class WeatherAPI_URL {

let FORECAST_WEATHER_URL = "http://api.wunderground.com/api/50e8ac2d75f2762e/geolookup/forecast/q/"
let CURRENT_WEATHER_URL = "http://api.wunderground.com/api/50e8ac2d75f2762e/conditions/q/"
let QUERY_URL = "http://autocomplete.wunderground.com/aq?query="
let LAT : String
let LONG : String
let city : String?
let query: String
let fullForecastURL : String
let fullConditionsURL : String
let cityFullForecastURL : String
let cityFullConditionsURL : String

    init(lat: String, long: String) {
        self.LAT = lat
        self.LONG = long
        self.fullForecastURL = ("\(FORECAST_WEATHER_URL)\(LAT),\(LONG).json")
        self.fullConditionsURL = ("\(CURRENT_WEATHER_URL)\(LAT),\(LONG).json")
        self.cityFullForecastURL = ""
        self.cityFullConditionsURL = ""
        self.city = ""
        self.query = ""
    }
    
    init(city: String) {
        
        self.LAT = ""
        self.LONG = ""
        self.fullForecastURL = ""
        self.fullConditionsURL = ""
        self.city = city
        self.query = "\(QUERY_URL)\(city)"
        self.cityFullForecastURL = "" //("\(FORECAST_WEATHER_URL)\(city).json")
        self.cityFullConditionsURL = "" //("\(CURRENT_WEATHER_URL)\(city).json")
        
        
    }
    
    
    
}
