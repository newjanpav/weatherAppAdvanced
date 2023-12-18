//
//  WeatherForCityViewController.swift
//  weatherApp
//
//  Created by Pavel Shymanski on 9.12.23.
//

import UIKit

class WeatherForCityViewController: UIViewController {
    
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var conditionWeatherImage: UIImageView!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    let currentWeather = WeatherDataLoader()
    var temperature: String?
    var weatherImage: UIImage?
    var cityName: String?
    var weatherDescription: String?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        temperatureLabel.text = temperature
        conditionWeatherImage.image = weatherImage
        cityNameLabel.text = cityName
        descriptionLabel.text = weatherDescription
    }
}




