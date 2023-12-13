//
//  CollectionViewCell.swift
//  weatherApp
//
//  Created by Pavel Shymanski on 13.12.23.
//

import UIKit

class HourlyCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var iconWeatherImage: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

}
