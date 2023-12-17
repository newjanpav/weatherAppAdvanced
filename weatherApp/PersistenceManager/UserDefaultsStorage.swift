//
//  WeatherObject.swift
//  weatherApp
//
//  Created by Pavel Shymanski on 14.12.23.
//

import Foundation


class UserDefaultsStorage {
    
    enum AppLanguage: String {
        case English = "en"
        case Russian = "ru"
    }
    let language = AppLanguage.RawValue()
    
    
    enum Key: String {
        case hourlyForecast
        case dailyForecast
        case lastUpdateKey
    }
    
    func getLastWord(forLanguage language: AppLanguage ) -> String {
        return (language == .Russian) ? "назад" : "ago"
    }
    
    
    func saveHourlyForecast (forecast: [HourlyWeatherToShow], forKey key: Key) {
        
        let lastTimeRequest = Date()
        UserDefaults.standard.set(lastTimeRequest, forKey: Key.lastUpdateKey.rawValue)
        
        let encoder = JSONEncoder()
        let data = try! encoder.encode(forecast)
        UserDefaults.standard.set(data, forKey: key.rawValue )
        
    }
    
    func retrieveHourlyForecast (forKey key: Key) -> ([HourlyWeatherToShow]?, dateRequest:Date?)  {
        let object =  UserDefaults.standard.value(forKey: key.rawValue)
        let decoder = JSONDecoder()
        guard let data = object  else { return (nil, nil) }
        
        let hourlyForecast = try? decoder.decode([HourlyWeatherToShow].self, from: data as! Data )
        let lastTimeRequest = UserDefaults.standard.value(forKey: Key.lastUpdateKey.rawValue) as! Date
        return (hourlyForecast,lastTimeRequest)
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
    
    
    func timeAgoSinceLastRequest() -> String {
        
        guard let timestamp = UserDefaults.standard.value(forKey: Key.lastUpdateKey.rawValue) as? Date else {
            return "No available Date"
        }
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .short
        formatter.maximumUnitCount = 0
        
        let now = Date()
        let components = Calendar.current.dateComponents([.second, .minute, .hour, .day], from: timestamp, to: now)
        
        let timeString = formatter.string(from: components) ??  "No available Date"
        
        let lastWord = getLastWord(forLanguage: .English)
        return "\(timeString) \(lastWord) "
    }
}
