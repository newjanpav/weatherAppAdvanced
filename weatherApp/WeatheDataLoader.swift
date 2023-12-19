//
//  WeatherManager.swift
//  weatherApp
//
//  Created by Pavel Shymanski on 7.12.23.
//

import Foundation
import CoreLocation


class WeatherDataLoader {
    
    let storageManager = UserDefaultsStorage()
    var hourlyWeatherDataList: [HourlyWeatherToShow] = []
    var dailyWeatherDataList : [DailyWeatherToShow] = []
    
    private var currentLanguage: String {
        if let language = Locale.current.languageCode {
            return language
        } else {
            return  "en"
        }
    }
    
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
    
    enum WeatherDataparamsKey : String {
        case apiKey = "appid"
        case units = "units"
        case city = "q"
        case latitude = "lat"
        case longitude = "lon"
        case exclude = "exclude"
        case language = "lang"
    }
    
    let baseUrlString = "https://api.openweathermap.org"
    let weatherPatch = "/data/2.5/weather"
    let weatherPathForHourlyAndDaily = "/data/2.5/onecall"
    let excludedParametrs = "current,minutely"
    let apiKey = "4529d030d5423024a977f7065add7d8c"
    
    
    func getTemperatureUnit() -> String {
        return (currentLanguage == "ru") ? "metric" : "imperial"
    }
    
    
    //MARK: -  Load Forecast with typing City Name
    func loadWeatherDataWithCityName(forCity city: String, completionHandler: @escaping (WeatherToShow?, Error?) -> Void) {
        
        let temperatureUnit = getTemperatureUnit()
        
        var components = URLComponents(string: baseUrlString)
        components?.path = weatherPatch
        
        let apiKeyItem = URLQueryItem(name: WeatherDataparamsKey.apiKey.rawValue, value: apiKey)
        let cityItem = URLQueryItem(name: WeatherDataparamsKey.city.rawValue, value: city)
        let unitsItem = URLQueryItem(name: WeatherDataparamsKey.units.rawValue, value: temperatureUnit)
        let languageItem = URLQueryItem(name: WeatherDataparamsKey.language.rawValue, value: currentLanguage)
        components?.queryItems = [cityItem,apiKeyItem,unitsItem,languageItem ]
        
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
    
 //MARK: - Creating URLRequst for Hourly and Daily Forecast
    func createURLForHourAndDay(latitude: CLLocationDegrees, longitude: CLLocationDegrees ) -> URLRequest? {
        
        let temperatureUnit = getTemperatureUnit()
        
        var  request: URLRequest?
        var components = URLComponents(string: baseUrlString)
        components?.path = weatherPathForHourlyAndDaily
        
        let apiKeyItem = URLQueryItem(name: WeatherDataparamsKey.apiKey.rawValue, value: apiKey)
        let unitsItem = URLQueryItem(name: WeatherDataparamsKey.units.rawValue, value: temperatureUnit)
        let longitudeItem = URLQueryItem(name: WeatherDataparamsKey.longitude.rawValue, value: String(longitude))
        let latitudeItem = URLQueryItem(name: WeatherDataparamsKey.latitude.rawValue, value: String(latitude))
        let excludeItem = URLQueryItem(name: WeatherDataparamsKey.exclude.rawValue, value: excludedParametrs)
        let languageItem = URLQueryItem(name: WeatherDataparamsKey.language.rawValue, value: currentLanguage)
        components?.queryItems = [apiKeyItem,unitsItem, longitudeItem, latitudeItem, excludeItem, languageItem]
        
        if let url = components?.url {
            request = URLRequest(url: url)
        }
        return request
    }
    
    //MARK: - Load Hourly an Daily Forecast
    
    func loadWeatherHourlyAndDailyData(latitude: CLLocationDegrees , longitude: CLLocationDegrees, completion: @escaping(([HourlyWeatherToShow],[DailyWeatherToShow])?, Error?) -> Void) {
        
        guard let  request = createURLForHourAndDay(latitude: latitude, longitude: longitude) else { return }
        
        let dataTask = URLSession.shared.dataTask(with: request) { [ weak self ]  data, respoce, error in
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
                    self?.hourFormatter.timeZone = TimeZone(identifier: weatherTimeZone)
                    let hour = self?.hourFormatter.string(from: formatedDate)
                    
                    let hourlyWeather = HourlyWeatherToShow(hour: hour!, hourlyTemperature: hourlyTemperature, hourlyWeatherId: hourlyId, weatherDescription: weatherdescription)
                    
                    self?.hourlyWeatherDataList.append(hourlyWeather)
                }
            }
            
            guard let safeWeatherMy = weather,
                  let daily = safeWeatherMy.daily else { return }
            for index in 0..<daily.count - 1 {
                
                if  let temperature = daily[index].temperature?.dayTemperature,
                    let weekDay = daily[index].dt,
                    let weatherArray = daily[index].weather,
                    let dailyId = weatherArray.first?.id,
                    let weatherTimeZone = safeWeatherMy.timeZone {
                    
                    let formatedDate = Date(timeIntervalSince1970: weekDay)
                    self?.dayFormatter.timeZone = TimeZone(identifier: weatherTimeZone)
                    let day = self?.dayFormatter.string(from: formatedDate)
                    
                    let dailyWeather = DailyWeatherToShow(day: day!, daylyTemperature: temperature, daylyWeatherId: dailyId)
                    self?.dailyWeatherDataList.append(dailyWeather)
                }
            }
            let forecast = Forecast(hourlyForecast: self!.hourlyWeatherDataList, dailyForecast: self!.dailyWeatherDataList)
            self?.storageManager.saveForecast(forecast: forecast, forKey: .hourlyForecast)
            
            completion((self?.hourlyWeatherDataList,self?.dailyWeatherDataList) as? ([HourlyWeatherToShow], [DailyWeatherToShow]),  nil)
        }
        dataTask.resume()
    }
    
}































































