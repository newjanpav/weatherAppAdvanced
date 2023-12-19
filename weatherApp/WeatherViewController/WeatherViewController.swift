//
//  WeatherViewController.swift
//  weatherApp
//
//  Created by Pavel Shymanski on 8.12.23.
//

import UIKit
import CoreLocation


protocol WeatherViewControllerDelegate: AnyObject {
    func monitorNetwork( _ controller: WeatherViewController)
}


class WeatherViewController: UIViewController {
    
    let locationManager = CLLocationManager()
    let currentWeather = WeatherDataLoader()
    var delegate = MonitorNetworkManager()
    var hourlyForecastCollectionView = HourlyForecastCollectionView()
    var dailyForecastTableView = DailyForecastTableView()
    
    @IBOutlet weak var lookForAweatherTextField: UITextField!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var conditionWeatherImage: UIImageView!
    @IBOutlet weak var descriptionWeatherLabel: UILabel!
    @IBOutlet weak var currentLocationLabel: UILabel!
    @IBOutlet weak var hourlyForecastLabel: UILabel!
    @IBOutlet weak var dailyForecastLabel: UILabel!
    @IBOutlet weak var locationErrorLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationErrorLabel.isHidden = true
        hourlyForecastLabel.isHidden = true
        dailyForecastLabel.isHidden = true
      
        delegate = MonitorNetworkManager()
        delegate.monitorNetwork(self)
        
        lookForAweatherTextField.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.locationManager.requestLocation()
        }
        
        view.addSubview(hourlyForecastCollectionView)
        hourlyForecastCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5).isActive = true
        hourlyForecastCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5).isActive = true
        hourlyForecastCollectionView.topAnchor.constraint(equalTo: hourlyForecastLabel.bottomAnchor, constant: 5)
            .isActive = true
        hourlyForecastCollectionView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        hourlyForecastCollectionView.backgroundColor = .clear
        
        view.addSubview(dailyForecastTableView)
        dailyForecastTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5).isActive = true
        dailyForecastTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5).isActive = true
        dailyForecastTableView.topAnchor.constraint(equalTo: hourlyForecastCollectionView.bottomAnchor, constant: 30).isActive = true
        dailyForecastTableView.heightAnchor.constraint(equalToConstant: 400).isActive = true
        dailyForecastTableView.backgroundColor = .clear
    
    }
}


extension WeatherViewController: UITextFieldDelegate {
    
    @IBAction func didTapLookForAWeather (_ sender: Any) {
        lookForAweatherTextField.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        lookForAweatherTextField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if lookForAweatherTextField.text != "" {
            return true
        } else {
            lookForAweatherTextField.placeholder = "Type a City"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let city = lookForAweatherTextField.text, !city.isEmpty {
            
            currentWeather.loadWeatherDataWithCityName(forCity: city) { [ weak self ] data, error in
                guard  let safeData = data  else {
                    
                    DispatchQueue.main.async {
                        self?.locationErrorLabel.text = "\(error?.localizedDescription ?? "Unknown Error")" }
                        return }
                
                DispatchQueue.main.async {
                    let vc = WeatherForCityViewController()
                    vc.temperature = safeData.temperatureString + "°"
                    vc.weatherDescription = safeData.weatherDescription
                    vc.weatherImage = UIImage(named: safeData.weatherImage)
                    vc.cityName = safeData.cityName
                    self?.present(vc,animated: true, completion: nil)
                }
            }
        }
        lookForAweatherTextField.text = ""
    }
}
     

extension WeatherViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            
            currentWeather.loadWeatherHourlyAndDailyData(latitude: lat, longitude: lon) { [ weak self ] data, error in
                guard let safeData = data  else {
                    DispatchQueue.main.async {
                        self?.locationErrorLabel.text = "\(error?.localizedDescription ?? "Unknown Error")" }
                    return }
                
                DispatchQueue.main.async {
                    let weather =  safeData.0[0]
                    self?.temperatureLabel.text = weather.temperatureString + "°"
                    self?.descriptionWeatherLabel.text = weather.weatherDescription
                    self?.conditionWeatherImage.image = UIImage(named: weather.weatherImage)
                    self?.hourlyForecastCollectionView.cells = safeData.0
                    self?.hourlyForecastCollectionView.reloadData()
                    self?.hourlyForecastLabel.isHidden = false
                    self?.dailyForecastTableView.cells = safeData.1
                    self?.dailyForecastTableView.reloadData()
                    self?.dailyForecastLabel.isHidden = false
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
}
 
    
   











































