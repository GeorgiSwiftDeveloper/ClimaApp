//
//  ViewController.swift
//  WeatherApp
//
//  Created by Angela Yu on 23/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import CoreLocation
import SwiftyJSON
import Alamofire


class WeatherViewController: UIViewController, CLLocationManagerDelegate, ChangeaCityDelegate {
   
    
    
    //Constants
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "e72ca729af228beabd5d20e3b7749713"
    /***Get your own App ID at https://openweathermap.org/appid ****/
    

    //TODO: Declare instance variables here
    let locationManager = CLLocationManager()
    let weatherDataModel = WeatherDataModel()

    
    //Pre-linked IBOutlets
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //TODO:Set up the location manager here.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        
    }
    
    
    
    //MARK: - Networking
    /***************************************************************/
    
    //Write the getWeatherData method here:
    
    func getWeatherData(url: String, parametrs: [String : String ]) {
        Alamofire.request(url, method: .get, parameters: parametrs).responseJSON { (respones) in
            if respones.result.isSuccess {
                let weatherResult: JSON = JSON(respones.result.value!)
                print(weatherResult)
                self.updateWeatherData(json: weatherResult)
            }else {
                print("something wrog")
                self.cityLabel.text = "Something heppend"
            }
        }
    }
    
    
    
    
    
    //MARK: - JSON Parsing
    /***************************************************************/
   
    
    //Write the updateWeatherData method here:
    
    func updateWeatherData(json: JSON) {
     let tempResult = json["main"]["temp"].double
    weatherDataModel.tempeture = Int(tempResult! - 273.15)
    weatherDataModel.city = json["name"].stringValue
    weatherDataModel.condition = json["weather"][0]["id"].intValue
    weatherDataModel.imageWeather = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition)
        updateUIWithWeather()
    }
    
    
    
    //MARK: - UI Updates
    /***************************************************************/
    
    
    //Write the updateUIWithWeatherData method here:
    func updateUIWithWeather() {
        cityLabel.text = weatherDataModel.city
        temperatureLabel.text = "\(weatherDataModel.tempeture)"
        weatherIcon.image = UIImage(named: weatherDataModel.imageWeather)
    }
    
    
    
    
    
    //MARK: - Location Manager Delegate Methods
    /***************************************************************/
    
    
    //Write the didUpdateLocations method here:
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            locationManager.startUpdatingLocation()
            let longitude = String(location.coordinate.longitude)
            let latitude = String(location.coordinate.latitude)
            let param: [String: String] = ["lon": longitude, "lat": latitude, "appid": APP_ID]
            getWeatherData(url: WEATHER_URL, parametrs: param)
        }
    }
    
    
    //Write the didFailWithError method here:
    
    
    

    
    //MARK: - Change City Delegate methods
    /***************************************************************/
    
    
    //Write the userEnteredANewCityName Delegate method here:
    
    func userEnterNewCityName(city: String) {
        let params: [String: String] = ["q": city, "appid": APP_ID]
        getWeatherData(url: WEATHER_URL, parametrs: params)
    }
    
    //Write the PrepareForSegue Method here
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "changeCityName" {
            let destinationVC = segue.destination as! ChangeCityViewController
            destinationVC.delegate = self
        }
    }
    
    
    
}


