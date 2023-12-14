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
        self.backgroundColor = .clear
    }
    override func layoutSubviews() {
            super.layoutSubviews()
            layer.cornerRadius = 15.0
            layer.borderWidth = 3.0
            layer.borderColor = UIColor.black.cgColor
            layer.masksToBounds = true
        }

}
