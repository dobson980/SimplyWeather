//
//  WeatherViewController.swift
//  SimplyWeather
//
//  Created by Tom Dobson on 8/21/17.
//  Copyright © 2017 Dobson Studios. All rights reserved.
//
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class WeatherViewController: UIViewController, CLLocationManagerDelegate, CitySelectDelegate, geoSelectedDelegate {
    
    // Mark: - Variables
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var currentWeatherLabel: UILabel!
    @IBOutlet weak var percipChanceLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    let locationManager = CLLocationManager()
    let weatherDataModel = WeatherDataModel()
    var citySelected: String?
    var usingGPS = true
    
    // Mark: - View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeLocation()
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longTouchAction))
        self.view.addGestureRecognizer(longPress)
        
        let swiperight = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction))
        swiperight.direction = .right
        
        let swipeleft = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction))
        swipeleft.direction = .left

        let swipeup = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction))
        swipeup.direction = .up
        
        self.view.addGestureRecognizer(swiperight)
        self.view.addGestureRecognizer(swipeleft)
        self.view.addGestureRecognizer(swipeup)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.initializeLocation), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    // MARK: - Location
    
    @objc func initializeLocation() {
        
        print("Initializing Location")
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations[locations.count - 1]
        
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            
            if usingGPS {
            
            let weatherAPICall = WeatherAPI_URL(lat: String(location.coordinate.latitude), long: String(location.coordinate.longitude))
            
                getWeatherData(forcastData: weatherAPICall.fullForecastURL, conditionsData: weatherAPICall.fullConditionsURL)
                
            }
            
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        print(error)
        cityLabel.text = "Location Unavailable"
        
    }
    
    // MARK : - Networking
    
    func query(city: String) {
        
        Alamofire.request(city).responseJSON {
            
            response in
            if response.result.isSuccess {
                
                let weatherJSON : JSON  = JSON(response.result.value!)
                print(weatherJSON)
                self.queryUpdateLatLong(json: weatherJSON)
                
            }  else {
                
                print("Error \(String(describing: response.result.error))")
                self.cityLabel.text = "Connection Error"
                
            }
            
        }
        
    }
    
    func getWeatherData(forcastData: String, conditionsData: String) {
        
        Alamofire.request(forcastData).responseJSON {

            response in
            if response.result.isSuccess {

                let weatherJSON : JSON  = JSON(response.result.value!)
                self.updateForeCastData(json: weatherJSON)

            } else {

                print("Error \(String(describing: response.result.error))")
                self.weatherDataModel.city = "Connection Error"
                self.updateUIwithErrorData()

            }


        }
        
        Alamofire.request(conditionsData).responseJSON {
            
            response in
            if response.result.isSuccess {
                
                let weatherJSON : JSON  = JSON(response.result.value!)
                self.updateWeatherData(json: weatherJSON)

                
            } else {
                
                print("Error \(String(describing: response.result.error))")
                self.weatherDataModel.city = "Connection Error"
                self.updateUIwithErrorData()
                
            }
            
        }
        
    }
    
    
    // MARK: - Parse JSON
    
    func queryUpdateLatLong(json: JSON) {
        
        if let lat = json["RESULTS"][0]["lat"].string, let lon = json["RESULTS"][0]["lon"].string {
            
            print(lat)
            print(lon)
            
            let weatherAPICall = WeatherAPI_URL(lat: lat, long: lon)
            
            getWeatherData(forcastData: weatherAPICall.fullForecastURL, conditionsData: weatherAPICall.fullConditionsURL)
            
        } else {
            
            weatherDataModel.city = "Can't Find City"
            updateUIwithErrorData()
            
        }
    }
    
    func updateWeatherData(json: JSON) {
        
        if let city = json["current_observation"]["display_location"]["city"].string {
        
        weatherDataModel.city = city
            
        } else { weatherDataModel.city = "Cant Get Weather"  }
        
        if let temperature = json["current_observation"]["temp_f"].double {
        
            weatherDataModel.temperature = String(format: "%.1f", temperature)
            
        } else { weatherDataModel.temperature = "??" }
        
        if let conditions = json["current_observation"]["weather"].string {
        
            weatherDataModel.conditions = conditions
            
        } else { weatherDataModel.conditions = "Error" }
        
        if let weatherIcon = json["current_observation"]["icon"].string {
            
            if let icon = UIImage(named: "\(weatherIcon).png") {
                
                weatherDataModel.weatherIcon = icon
                
            } else { weatherDataModel.weatherIcon = #imageLiteral(resourceName: "uknown") }
            
        } else { weatherDataModel.weatherIcon = #imageLiteral(resourceName: "uknown") }
        
        if let timeStamp = json["current_observation"]["local_time_rfc822"].string {
            
            weatherDataModel.time = weatherDataModel.getTime(time: timeStamp)
            weatherDataModel.date = weatherDataModel.getDate(date: timeStamp)
            
        } else { timeLabel.text = "00:00"; dateLabel.text = "Nil 99"}
        
        updateUIWithWeatherData()
        
    }
    
    func updateForeCastData(json: JSON) {
        
        if let precip = json["forecast"]["txt_forecast"]["forecastday"][0]["pop"].string {
            
            weatherDataModel.precip = "\(precip)%"
            
        } else { weatherDataModel.precip = "XX%"}
        
        updateUIWithWeatherData()
        
    }
    
    // MARK: - UI Updates
    
    func updateUIWithWeatherData() {
        
        cityLabel.text = weatherDataModel.city
        currentWeatherLabel.text = weatherDataModel.conditions
        temperatureLabel.text = weatherDataModel.temperature
        timeLabel.text = weatherDataModel.time
        dateLabel.text = weatherDataModel.date
        percipChanceLabel.text = weatherDataModel.precip
        weatherIcon.image = weatherDataModel.weatherIcon
        
    }
    
    func updateUIwithErrorData() {
        
        cityLabel.text = weatherDataModel.city
        currentWeatherLabel.text = ""
        temperatureLabel.text = ""
        timeLabel.text = ""
        dateLabel.text = ""
        percipChanceLabel.text = "0%"
        weatherIcon.image = #imageLiteral(resourceName: "uknown")
        
    }
    
    // MARK: - Gestures
    
    @objc func longTouchAction(gesture: UILongPressGestureRecognizer) {
        
        if gesture.state == .began {
            
            gesture.tapticFeedback()
            initializeLocation()
            updateUIWithWeatherData()
            
        }
        
    }
    
    @objc func swipeAction(gesture: UISwipeGestureRecognizer) {
        
        switch gesture.direction {
            
            case .right: performSegue(withIdentifier: "citySelector", sender: nil)
            case .left: print("left")
            case .down: print("down")
            case .up: print("up")
            default: break
            
        }
            
    }
    
    // MARK: - Delegates
    
    func userEnteredAnewCityName(city: String) {
        
        usingGPS = false
        citySelected = city.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
        let weatherAPICALL = WeatherAPI_URL(city: citySelected!)
        print(weatherAPICALL)
        query(city: weatherAPICALL.query)
        
    }
    
    func geoSelected() {
        
        usingGPS = true
        initializeLocation()
        updateUIWithWeatherData()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "citySelector" {
            
            let destinationVC = segue.destination as! CitySelectVIewController
            
            destinationVC.delegate = self
            destinationVC.geoDelegate = self
                        
        }
    
        
    }
        
}



