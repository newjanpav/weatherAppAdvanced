//
//  WeatherManager.swift
//  weatherApp
//
//  Created by Pavel Shymanski on 7.12.23.
//

import Foundation
import CoreLocation

protocol WeatherDataLoaderDelegate {
    func didUpdateWeather(weather: WeatherToShow)
}



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
    
        
    func loadWeatherDataWithLocation(latitude: CLLocationDegrees , longitude: CLLocationDegrees, completionHandler: @escaping (WeatherToShow?, Error?) -> Void) {
        
        var components = URLComponents(string: baseUrlString)
        components?.path = weatherPatch
        
        let apiKeyItem = URLQueryItem(name: WeatherDataparamsKey.apiKey.rawValue, value: apiKey)
        let unitsItem = URLQueryItem(name: WeatherDataparamsKey.units.rawValue, value: units)
        let latitudeItem = URLQueryItem(name: WeatherDataparamsKey.latitude.rawValue, value: String(latitude))
        let longitudeItem = URLQueryItem(name: WeatherDataparamsKey.longitude.rawValue, value: String(longitude))
        
        components?.queryItems = [apiKeyItem, unitsItem, latitudeItem, longitudeItem ]
        
        guard let url = components?.url else { return }
        perform(url: url) { weather, error in
            completionHandler(weather, nil)
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
               let minTemperatureToShow = weatherData?.temperature?.temperatureMin,
               let maxTemperarureToShow = weatherData?.temperature?.temperatureMax,
               let weatherId = weatherData?.weatherDescription?[0].id    {
                
                let weather = WeatherToShow(temperature: temperatureToShow, temperatureMax: maxTemperarureToShow, temperatureMin: minTemperatureToShow, weatherDescription: descriptionToShow, weatherId: weatherId)
                
                completionHandler(weather, nil)
            }
        }
        dataTask.resume()
    }
}
        
    
    
    
    
    
    
    
    
    
    
    

    
    
    
    















