//
//  WeatherManager.swift
//  weatherApp
//
//  Created by Pavel Shymanski on 7.12.23.
//

import Foundation
import CoreLocation


//request for hours
//https://api.openweathermap.org/data/2.5/forecast?lat=57&lon=-2.15&cnt=3&appid={API key}

//let apiUrl = "https://api.openweathermap.org/data/2.5/onecall?lat=\(latitude)&lon=\(longitude)&exclude=current,minutely,daily&appid=\(apiKey)"





class WeatherDataLoader {
    
    enum WeatherDataparamsKey : String {
        case apiKey = "appid"
        case units = "units"
        case city = "q"
        case latitude = "lat"
        case longitude = "lon"
    }
    
    let baseUrlString = "https://api.openweathermap.org"
    let weatherPatch = "/data/2.5/weather"
    let apiKey = "4529d030d5423024a977f7065add7d8c"
    let units = "metric"
    
    var hourlyWeatherDataList: [HourlyWeatherToShow] = []
    
    
    private var hourFormatter: DateFormatter {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "ha"
        return dateFormater
    }
    

    func loadWeatherDataWithCityName(forCity city: String, completionHandler: @escaping (WeatherToShow?, Error?) -> Void) {
        
        var components = URLComponents(string: baseUrlString)
        components?.path = weatherPatch
        
        let apiKeyItem = URLQueryItem(name: WeatherDataparamsKey.apiKey.rawValue, value: apiKey)
        let cityItem = URLQueryItem(name: WeatherDataparamsKey.city.rawValue, value: city)
        let unitsItem = URLQueryItem(name: WeatherDataparamsKey.units.rawValue, value: units)
        components?.queryItems = [cityItem,apiKeyItem,unitsItem]
        
        guard let url = components?.url else { return }
        perform(url: url) { weather, error in
            completionHandler(weather, nil)
        }
    }
    
        
    func loadWeatherDataHourly(latitude: CLLocationDegrees , longitude: CLLocationDegrees, completion: @escaping([HourlyWeatherToShow]?, Error?) -> Void) {
        
        let apiUrl = "https://api.openweathermap.org/data/2.5/onecall?lat=\(latitude)&lon=\(longitude)&exclude=current,minutely,daily&units=metric&appid=\(apiKey)"
        
        if let url = URL(string: apiUrl) {
            let dataTask = URLSession.shared.dataTask(with: url) { data, respoce, error in
                guard error == nil , let safeData = data else  { return }
                let decoder = JSONDecoder()
                let weather = try? decoder.decode(WeatherData.self, from: safeData)
                
                guard  let safeWeather = weather,
                       let hourly = safeWeather.hourly else  { return }
                
                let lastHour = min(5,hourly.count)
                
                for index  in 0...lastHour {
                    
                    if let hour = hourly[index].dt,
                       let hourlyTemperature = hourly[index].temperature,
                       let weatherArray = hourly[index].weather,
                       let weatherTimeZone = safeWeather.timeZone,
                       let weatherdescription = weatherArray.first?.description,
                       let hourlyId = weatherArray.first?.id   {
                        
                        let formatedDate = Date(timeIntervalSince1970: hour)
                        self.hourFormatter.timeZone = TimeZone(identifier: weatherTimeZone)
                        let hour = self.hourFormatter.string(from: formatedDate)
                        
                        let hourlyWeather = HourlyWeatherToShow(hour: hour, hourlyTemperature: hourlyTemperature, hourlyWeatherId: hourlyId, weatherDescription: weatherdescription)
                        
                        self.hourlyWeatherDataList.append(hourlyWeather)
                        
                        print("Hour \(hour)  Temperature: \(hourlyTemperature)  Id: \(hourlyId)")
                        
                        completion(self.hourlyWeatherDataList, nil)
                    }
                }
            }
            dataTask.resume()
        }
    }
    
    
    func perform (url: URL,completionHandler: @escaping (WeatherToShow?, Error?) ->Void) {
        let request = URLRequest(url:url )
        let dataTask =  URLSession.shared.dataTask(with: request) { data, responce, error in
            guard  error  == nil , let safedata = data else  { return }
            
            let decoder = JSONDecoder()
            let weatherData = try? decoder.decode(WeatherData.self, from: safedata)
            
            if let cityName = weatherData?.cityName,
               let temperatureToShow = weatherData?.temperature?.temperature,
               let descriptionToShow = weatherData?.weatherDescription?[0].description,
               let weatherId = weatherData?.weatherDescription?[0].id
            {
                let weather = WeatherToShow(cityName:cityName, temperature: temperatureToShow, weatherDescription: descriptionToShow, weatherId: weatherId)
                completionHandler(weather, nil)
            }
        }
        dataTask.resume()
    }
}
     








//func loadWeatherDataWithLocation(latitude: CLLocationDegrees , longitude: CLLocationDegrees, completionHandler: @escaping (WeatherToShow?, Error?) -> Void) {
//
//    var components = URLComponents(string: baseUrlString)
//    components?.path = weatherPatch
//
//    let apiKeyItem = URLQueryItem(name: WeatherDataparamsKey.apiKey.rawValue, value: apiKey)
//    let unitsItem = URLQueryItem(name: WeatherDataparamsKey.units.rawValue, value: units)
//    let latitudeItem = URLQueryItem(name: WeatherDataparamsKey.latitude.rawValue, value: String(latitude))
//    let longitudeItem = URLQueryItem(name: WeatherDataparamsKey.longitude.rawValue, value: String(longitude))
//
//    components?.queryItems = [apiKeyItem, unitsItem, latitudeItem, longitudeItem ]
//
//    guard let url = components?.url else { return }
//    perform(url: url) { weather, error in
//        completionHandler(weather, nil)
//    }
//}
//











    
    
    
    
    
    
    
    
    
    
    

    
    
    
    















