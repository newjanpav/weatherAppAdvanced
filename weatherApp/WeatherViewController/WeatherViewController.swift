//
//  WeatherViewController.swift
//  weatherApp
//
//  Created by Pavel Shymanski on 8.12.23.
//

import UIKit
import CoreLocation



class WeatherViewController: UIViewController {
    
    let storage = UserDefaultsStorage()

    @IBOutlet weak var lookForAweatherTextField: UITextField!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var conditionWeatherImage: UIImageView!
    @IBOutlet weak var descriptionWeatherLabel: UILabel!
    @IBOutlet weak var currentLocation: UILabel!
    @IBOutlet weak var hourlyForecastLabel: UILabel!
    @IBOutlet weak var dailyForecastLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    private var hourlyForecastCollectionView = HourlyForecastCollectionView()
    private var dailyForecastTableView = DailyForecastTableView()

    let locationManager = CLLocationManager()
    let currentWeather = WeatherDataLoader()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        lookForAweatherTextField.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
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
        
        hourlyForecastLabel.isHidden = true
        dailyForecastLabel.isHidden = true
        activityIndicator.isHidden = true
        
    }
    
    @IBAction func showLocation(_ sender: UIButton) {
        locationManager.requestLocation()
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
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
            
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            
            currentWeather.loadWeatherDataWithCityName(forCity: city) { data, error in
                guard  let safeData = data  else { return }
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                    let vc = WeatherForCityViewController()
                    vc.temperature = safeData.temperatureString + "°"
                    vc.weatherImage = UIImage(named: safeData.weatherImage)
                    vc.cityName = safeData.cityName
                    self.present(vc,animated: true, completion: nil)
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
            
            currentWeather.loadWeatherDataHourly(latitude: lat, longitude: lon) { [ weak self ] data, error in
                guard let safeData = data  else { return }
                DispatchQueue.main.async {
                    self?.activityIndicator.stopAnimating()
                    self?.activityIndicator.isHidden = true
                    let weather =  safeData[0]
                    self?.temperatureLabel.text = weather.temperatureString + "°"
                    self?.descriptionWeatherLabel.text = weather.weatherDescription
                    self?.conditionWeatherImage.image = UIImage(named: weather.weatherImage)
                    self?.hourlyForecastCollectionView.cells = safeData
                    self?.hourlyForecastCollectionView.reloadData()
                    self?.hourlyForecastLabel.isHidden = false
                }
            }
            currentWeather.loadWeatherDataDaily(latitude: lat, longitude: lon) { [ weak self ] data, error in
                guard let safeData = data else { return }
                DispatchQueue.main.async {
                    self?.dailyForecastTableView.cells = safeData
                    self?.dailyForecastTableView.reloadData()
                    self?.dailyForecastLabel.isHidden = false
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        currentLocation.text = "Location error"
    }
}
    
    
   











































