//
//  MonitorNetworkManager.swift
//  weatherApp
//
//  Created by Pavel Shymanski on 16.12.23.
//

import Foundation
import UIKit
import Network

class MonitorNetworkManager: WeatherViewControllerDelegate {
    
    var lastUpdatedate = Date()
    
//    private var dayFormatter: DateFormatter {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "EEEE"
//        return dateFormatter
//    }
    
    
    let storage = UserDefaultsStorage()
    
    func monitorNetwork(_ controller: WeatherViewController) {
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                monitor.cancel()
            } else {
                DispatchQueue.main.async {
                    guard let hourlyData:([HourlyWeatherToShow],Date) = self.storage.retrieveHourlyForecast(forKey: .hourlyForecast) as? ([HourlyWeatherToShow], Date),
                          
                          let dailyData = self.storage.retrieveDailyForecast(forKey: .dailyForecast) else {
                        controller.currentLocationLabel.text = "There are no available Data"
                        return }
                    
                    let hourlyWeather = hourlyData.0
                    controller.temperatureLabel.text = hourlyWeather[0].temperatureString + "°"
                    controller.descriptionWeatherLabel.text = hourlyWeather[0].weatherDescription
                    controller.conditionWeatherImage.image = UIImage(named: hourlyWeather[0].weatherImage)
                    controller.hourlyForecastCollectionView.cells = hourlyWeather
                    controller.hourlyForecastCollectionView.reloadData()
                    controller.hourlyForecastLabel.isHidden = false
                    
                    
                    //for test
                    self.lastUpdatedate = hourlyData.1
                    //
                    
                    let dailyWeather = dailyData
                    controller.dailyForecastTableView.cells = dailyWeather
                    controller.dailyForecastTableView.reloadData()
                    controller.dailyForecastLabel.isHidden = false
                }
            }
        }
        let queue = DispatchQueue(label: "com.monitorNetworkQueue.serialQueie")
        monitor.start(queue: queue)
        //for test
        print("___________\(lastUpdatedate)__________")
       
        
    }
}
