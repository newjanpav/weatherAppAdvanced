//
//  WeatherViewController.swift
//  weatherApp
//
//  Created by Pavel Shymanski on 8.12.23.
//

import UIKit
import CoreLocation



class WeatherViewController: UIViewController {

    @IBOutlet weak var lookForAweatherTextField: UITextField!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var conditionWeatherImage: UIImageView!
    @IBOutlet weak var descriptionWeatherLabel: UILabel!
    @IBOutlet weak var minMaxTemperatureLabel: UILabel!
    @IBOutlet weak var currentLocation: UILabel!
    
//    private var hourlyForecastCollectionView = UICollectionView(frame: <#T##CGRect#>, collectionViewLayout: <#T##UICollectionViewLayout#>)
//

    let locationManager = CLLocationManager()
    let currentWeather = WeatherDataLoader()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        lookForAweatherTextField.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestLocation()
        locationManager.requestWhenInUseAuthorization()
    }
    
    
    //test
    @IBAction func showLocation(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    func didUpdateWeather(weather: HourlyWeatherToShow) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString + "°"
            self.descriptionWeatherLabel.text = weather.weatherDescription
            self.conditionWeatherImage.image = UIImage(named: weather.weatherImage)
        }
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
           
            currentWeather.loadWeatherDataWithCityName(forCity: city) { data, error in
                if let safeData = data {
                    DispatchQueue.main.async {
                        let vc = WeatherForCityViewController()
                        vc.temperature = safeData.temperatureString + "°"
                        vc.weatherImage = UIImage(named: safeData.weatherImage)
                        vc.cityName = safeData.cityName
                        self.present(vc,animated: true, completion: nil)
                    }
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
                if let safeData = data {
                    self?.didUpdateWeather(weather: safeData[0])
                }
            }
        }
    }
  
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        currentLocation.text = "Location error"
    }
}













































//import UIKit
//import CoreLocation
//
//
//class WeatherViewController: UIViewController {
//
//    @IBOutlet weak var lookForAWeatherTextField: UITextField!
//    @IBOutlet weak var temperatureLabel: UILabel!
//    @IBOutlet weak var conditionWeatherImage: UIImageView!
//    @IBOutlet weak var descriptionWeatherLabel: UILabel!
//    @IBOutlet weak var minMaxTemperatureLabel: UILabel!
//    @IBOutlet weak var currentLocation: UILabel!
//
//
//    let locationManager = CLLocationManager()
//    let currentWeather = WeatherDataLoader()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        locationManager.requestWhenInUseAuthorization()
//        lookForAWeatherTextField.delegate = self
//        locationManager.delegate = self
//        locationManager.requestLocation()
//
//    }
//}
//
//
//extension WeatherViewController: UITextFieldDelegate {
//
//    @IBAction func didTapLookForAWeather (_ sender: Any) {
//        lookForAWeatherTextField.endEditing(true)
//    }
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        lookForAWeatherTextField.endEditing(true)
//        return true
//    }
//
//    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
//        if lookForAWeatherTextField.text != "" {
//            return true
//        } else {
//            lookForAWeatherTextField.placeholder = "Type a City"
//            return false
//        }
//    }
//
//    func textFieldDidEndEditing(_ textField: UITextField) {
//
//        if let city = lookForAWeatherTextField.text {
//            currentWeather.loadWeatherDataWithCityName(forCity: city) { [weak self ] data, error in
//                if let safeData = data {
//                    self?.didUpdateWeather(weather: safeData)

//                }
//            }
//            lookForAWeatherTextField.text = " "
//        }
//    }
//}
//
//
//extension WeatherViewController: CLLocationManagerDelegate {
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        if let location = locations.last {
//            locationManager.stopUpdatingLocation()
//            let lat = location.coordinate.latitude
//            let lon = location.coordinate.longitude
//            currentWeather.loadWeatherDataWithLocation(latitude: lat, longitude: lon) { [ weak self ] data, error in
//                if let safeData = data {
//                    self?.didUpdateWeather(weather: safeData)
//                }
//            }
//        }
//    }
//
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        currentLocation.text = "Location error "
//    }
//}
//
//
//extension WeatherViewController: WeatherDataLoaderDelegate {
//
//    func didUpdateWeather(weather: WeatherToShow) {
//        DispatchQueue.main.async {
//
//            self.temperatureLabel.text = weather.temperatureString + "°"
//            self.descriptionWeatherLabel.text = weather.weatherDescription
//            self.minMaxTemperatureLabel.text = ("Max:\(weather.temperatureMaxString)° Min: \(weather.temperatureMinString)°")
//            self.conditionWeatherImage.image = UIImage(named: weather.weatherImage)
//        }
//    }
//}
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
