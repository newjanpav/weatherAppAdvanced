//
//  WeatherObject.swift
//  weatherApp
//
//  Created by Pavel Shymanski on 14.12.23.
//

import Foundation


class UserDefaultsStorage {
    
    private var currentLanguage: String {
        if let language = Locale.current.languageCode {
            return language
        } else {
            return  "en"
        }
    }
    
    enum Key: String {
        case hourlyForecast
        case dailyForecast
        case lastUpdateKey
    }
    
    func giveLastWord() -> String {
        return (currentLanguage == "ru") ? "назад" : "ago"
    }
    
    func saveForecast (forecast:Forecast ,forKey key: Key) {
        let lastTimeRequest = Date()
        UserDefaults.standard.set(lastTimeRequest, forKey: Key.lastUpdateKey.rawValue)
        
        let encoder = JSONEncoder()
        let data = try! encoder.encode(forecast)
        UserDefaults.standard.set(data, forKey: key.rawValue )
    }
    
    func retrieveForecast (forKey key: Key) -> (Forecast?, dateRequest:Date?)  {
        let object =  UserDefaults.standard.value(forKey: key.rawValue)
        let decoder = JSONDecoder()
        guard let data = object  else { return (nil, nil) }
        
        let hourlyForecast = try? decoder.decode(Forecast.self, from: data as! Data )
        let lastTimeRequest = UserDefaults.standard.value(forKey: Key.lastUpdateKey.rawValue) as! Date
        return (hourlyForecast,lastTimeRequest)
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
        let lastWord = giveLastWord()
        return "\(timeString) \(lastWord) "
    }
}







