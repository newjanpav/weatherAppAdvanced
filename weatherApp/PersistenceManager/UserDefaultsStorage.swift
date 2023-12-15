//
//  WeatherObject.swift
//  weatherApp
//
//  Created by Pavel Shymanski on 14.12.23.
//

import Foundation


class UserDefaultsStorage {
    
    enum Key: String {
        case hourlyForecast
        case dailyForecast
    }
    
    
    func saveHourlyForecast (forecast: [HourlyWeatherToShow], forKey key: Key) {
        let encoder = JSONEncoder()
        let data = try! encoder.encode(forecast)
        UserDefaults.standard.set(data, forKey: key.rawValue )
       
    }
    
    func retrieveHourlyForecast (forKey key: Key) -> [HourlyWeatherToShow]? {
        let object =  UserDefaults.standard.value(forKey: key.rawValue)
        let decoder = JSONDecoder()
        guard let data = object  else { return nil }
        let hourlyForecast = try? decoder.decode([HourlyWeatherToShow].self, from: data as! Data )
        return hourlyForecast
    }
    
    func saveDailyForecast (forecast: [DailyWeatherToShow], forKey key: Key) {
        let encoder = JSONEncoder()
        let data = try! encoder.encode(forecast)
        UserDefaults.standard.set(data, forKey: key.rawValue )
       
    }
    
    func retrieveDailyForecast (forKey key: Key) -> [DailyWeatherToShow]? {
        let object  = UserDefaults.standard.value(forKey: key.rawValue)
        let decoder = JSONDecoder()
        guard let data = object  else { return nil }
        let dailyForecast = try? decoder.decode([DailyWeatherToShow].self, from: data as! Data )
        return dailyForecast
    }
}


