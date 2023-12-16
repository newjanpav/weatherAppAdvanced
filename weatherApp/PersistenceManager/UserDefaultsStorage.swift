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
        case lastUpdateKey
    }
    
    func saveHourlyForecast (forecast: [HourlyWeatherToShow], forKey key: Key) {
        
        let lastTimeRequest = Date()
        UserDefaults.standard.set(lastTimeRequest, forKey: Key.lastUpdateKey.rawValue)
        
        let encoder = JSONEncoder()
        let data = try! encoder.encode(forecast)
        UserDefaults.standard.set(data, forKey: key.rawValue )
       
    }
    
    func retrieveHourlyForecast (forKey key: Key) -> ([HourlyWeatherToShow]?, timeRequest:Date?)  {
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
    
//
//    func dataAge() -> String {
//           guard let timestamp = UserDefaults.standard.value(forKey: Key.lastUpdateKey.rawValue) as? Date else {
//               return "No data available"
//           }
//
//           let currentTime = Date()
//           let timeDifference = currentTime.timeIntervalSince(timestamp)
//
//           if timeDifference < 60 {
//               return "\(Int(timeDifference)) seconds ago"
//           } else if timeDifference < 3600 {
//               return "\(Int(timeDifference / 60)) minutes ago"
//           } else if timeDifference < 86400 {
//               return "\(Int(timeDifference / 3600)) hours ago"
//           } else {
//               let dateFormatter = DateFormatter()
//               dateFormatter.dateFormat = "MMM d, yyyy 'at' h:mm a"
//               return dateFormatter.string(from: timestamp)
//           }
//       }
    
}


