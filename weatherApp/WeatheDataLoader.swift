//
//  WeatherManager.swift
//  weatherApp
//
//  Created by Pavel Shymanski on 7.12.23.
//

import Foundation
import CoreLocation

class WeatherDataLoader {
    
    var hourlyWeatherDataList: [HourlyWeatherToShow] = []
    var dailyWeatherDataList : [DailyWeatherToShow] = []
    
    enum WeatherDataparamsKey : String {
        case apiKey = "appid"
        case units = "units"
        case city = "q"
        case latitude = "lat"
        case longitude = "lon"
        case exclude = "exclude"
    }
    
    let baseUrlString = "https://api.openweathermap.org"
    let weatherPatch = "/data/2.5/weather"
    let weatherPathForHourlyAndDaily = "/data/2.5/onecall"
    let excludedParametrs = "current,minutely"
    let apiKey = "4529d030d5423024a977f7065add7d8c"
    let units = "metric"
    
    
    private var hourFormatter: DateFormatter {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "ha"
        return dateFormater
    }
    
    private var dayFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter
    }
    
    
    
    func loadWeatherDataWithCityName(forCity city: String, completionHandler: @escaping (WeatherToShow?, Error?) -> Void) {
        
        var components = URLComponents(string: baseUrlString)
        components?.path = weatherPatch
        
        let apiKeyItem = URLQueryItem(name: WeatherDataparamsKey.apiKey.rawValue, value: apiKey)
        let cityItem = URLQueryItem(name: WeatherDataparamsKey.city.rawValue, value: city)
        let unitsItem = URLQueryItem(name: WeatherDataparamsKey.units.rawValue, value: units)
        components?.queryItems = [cityItem,apiKeyItem,unitsItem]
        
        guard let url = components?.url else { return }
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
    
    
    func createURLForHourAndDay(latitude: CLLocationDegrees, longitude: CLLocationDegrees ) -> URLRequest? {
        
        var  request: URLRequest?
        var components = URLComponents(string: baseUrlString)
        components?.path = weatherPathForHourlyAndDaily
        
        let apiKeyItem = URLQueryItem(name: WeatherDataparamsKey.apiKey.rawValue, value: apiKey)
        let unitsItem = URLQueryItem(name: WeatherDataparamsKey.units.rawValue, value: units)
        let longitudeItem = URLQueryItem(name: WeatherDataparamsKey.longitude.rawValue, value: String(longitude))
        let latitudeItem = URLQueryItem(name: WeatherDataparamsKey.latitude.rawValue, value: String(latitude))
        let excludeItem = URLQueryItem(name: WeatherDataparamsKey.exclude.rawValue, value: excludedParametrs)
        components?.queryItems = [apiKeyItem,unitsItem, longitudeItem, latitudeItem, excludeItem]
        
        if let url = components?.url {
            request = URLRequest(url: url)
        }
        return request
    }
    
    //MARK: - Load Hourly Weather Data
    
    func loadWeatherDataHourly(latitude: CLLocationDegrees , longitude: CLLocationDegrees, completion: @escaping([HourlyWeatherToShow]?, Error?) -> Void) {
    
        guard let  request = createURLForHourAndDay(latitude: latitude, longitude: longitude) else { return }
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, respoce, error in
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
                   let hourlyId = weatherArray.first?.id {
                    
                    let formatedDate = Date(timeIntervalSince1970: hour)
                    self.hourFormatter.timeZone = TimeZone(identifier: weatherTimeZone)
                    let hour = self.hourFormatter.string(from: formatedDate)
                    
                    let hourlyWeather = HourlyWeatherToShow(hour: hour, hourlyTemperature: hourlyTemperature, hourlyWeatherId: hourlyId, weatherDescription: weatherdescription)
                    
                    self.hourlyWeatherDataList.append(hourlyWeather)
                    print("Hour \(hour)  Temperature: \(hourlyTemperature)  Id: \(hourlyId)")
                }
            }
            completion(self.hourlyWeatherDataList, nil)
        }
        dataTask.resume()
    }
    
    // MARK: - Load Daily Weather Data
    
    func loadWeatherDataDaily(latitude: CLLocationDegrees , longitude: CLLocationDegrees, completion: @escaping([DailyWeatherToShow]?, Error?) -> Void) {
    
        guard let  request = createURLForHourAndDay(latitude: latitude, longitude: longitude) else { return }
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil, let safeData = data else { return }
            let decoder = JSONDecoder()
            let dailyWeather = try? decoder.decode(WeatherData.self, from: safeData)
            
            guard let safeWeather = dailyWeather,
                  let daily = dailyWeather?.daily else { return }
            for index in 0..<daily.count - 1 {
                
                if  let temperature = daily[index].temperature?.dayTemperature,
                    let weekDay = daily[index].dt,
                    let weatherArray = daily[index].weather,
                    let dailyId = weatherArray.first?.id,
                    let weatherTimeZone = safeWeather.timeZone {
                    
                    let formatedDate = Date(timeIntervalSince1970: weekDay)
                    self.dayFormatter.timeZone = TimeZone(identifier: weatherTimeZone)
                    let day = self.dayFormatter.string(from: formatedDate)
                    
                    let dailyWeather = DailyWeatherToShow(day: day, daylyTemperature: temperature, daylyWeatherId: dailyId)
                    self.dailyWeatherDataList.append(dailyWeather)
                    
                    print("Day: \(day)  Temperature: \(temperature)  Id: \(dailyId)")
                }
            }
            completion(self.dailyWeatherDataList, nil)
        }
        dataTask.resume()
    }
}

    
   













