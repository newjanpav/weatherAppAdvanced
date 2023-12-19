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
    
   let storage = UserDefaultsStorage()
   
    func monitorNetwork(_ controller: WeatherViewController) {
      
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { [ weak self ] path in
            if path.status == .satisfied {
                monitor.cancel()
            } else {
                DispatchQueue.main.async {
                    guard let forecastFromStorage:(Forecast,Date) = self?.storage.retrieveForecast(forKey: .hourlyForecast) as? (Forecast, Date) else {
                        controller.locationErrorLabel.isHidden = false
                        controller.currentLocationLabel.text = "There are no available Data"
                        return }
                    controller.locationErrorLabel.isHidden = false
                    let forecast = forecastFromStorage.0
                    controller.temperatureLabel.text = forecast.hourlyForecast[0].temperatureString + "°"
                    controller.descriptionWeatherLabel.text = forecast.hourlyForecast[0].weatherDescription
                    controller.conditionWeatherImage.image = UIImage(named: forecast.hourlyForecast[0].weatherImage)
                    controller.hourlyForecastCollectionView.cells = forecast.hourlyForecast
                    controller.hourlyForecastCollectionView.reloadData()
                    controller.hourlyForecastLabel.isHidden = false
                    
                    controller.dailyForecastTableView.cells = forecast.dailyForecast
                    controller.dailyForecastTableView.reloadData()
                    controller.dailyForecastLabel.isHidden = false
                    controller.currentLocationLabel.text = self?.storage.timeAgoSinceLastRequest()
                }
            }
        }
        let queue = DispatchQueue(label: "com.monitorNetworkQueue.serialQueie")
        monitor.start(queue: queue)
    }
    
}
