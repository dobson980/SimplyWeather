//
//  WeatherModel.swift
//  SimplyWeather
//
//  Created by Tom Dobson on 8/21/17.
//  Copyright © 2017 Dobson Studios. All rights reserved.

import UIKit

class WeatherDataModel {
    
    var city : String = ""
    var conditions : String = ""
    var weatherIcon : UIImage = #imageLiteral(resourceName: "uknown")
    var temperature : String = ""
    var time : String = ""
    var date : String = ""
    var precip : String = ""
        
}

extension WeatherDataModel {
    
    func getTime(time: String) -> String {
        
        let start = time.index(time.startIndex, offsetBy: 17)
        let end = time.index(time.endIndex, offsetBy: -9)
        let extractedTime = String(time[start..<end])
        return extractedTime
        
    }
    
}

extension WeatherDataModel {
    
    func getDate(date: String) -> String {
    
        let monthStart = date.index(date.startIndex, offsetBy: 8)
        let monthEnd = date.index(date.endIndex, offsetBy: -20)
        let month = date[monthStart..<monthEnd]
        
        let dayStart = date.index(date.startIndex, offsetBy: 5)
        let dayEnd = date.index(date.endIndex, offsetBy: -24)
        let day = date[dayStart..<dayEnd]
        
        return "\(month) \(day)"
        
    }
    
}

extension WeatherDataModel {
    
    
    func getLocalTime() {
        
    let time = Date().description(with: Locale.current)
    
    let timeStart = time.index(time.startIndex, offsetBy: 28)
    let timeEnd = time.index(time.endIndex, offsetBy: -22)
    let extractedTime = String(time[timeStart..<timeEnd])
    
    let timeFormatter = DateFormatter()
    timeFormatter.dateFormat = "h:mm:ss a"
    let date = timeFormatter.date(from: extractedTime)
    
    timeFormatter.dateFormat = "HH:mm"
    let date24 = timeFormatter.string(from: date!)
    
    self.time = date24
        
    }
    
}


