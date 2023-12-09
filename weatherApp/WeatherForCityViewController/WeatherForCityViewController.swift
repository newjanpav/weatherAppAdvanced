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

    
    let currentWeather = WeatherDataLoader()
    var temperature: String?
    var weatherImage: UIImage?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        temperatureLabel.text = temperature
        conditionWeatherImage.image = weatherImage
    }
}




