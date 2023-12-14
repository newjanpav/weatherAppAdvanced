//
//  DailyTableViewCell.swift
//  weatherApp
//
//  Created by Pavel Shymanski on 14.12.23.
//

import UIKit

class DailyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var weekDayLabel: UILabel!
    @IBOutlet weak var iconWeatherImage: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
    }
    
    override func layoutSubviews() {
            super.layoutSubviews()
            layer.cornerRadius = 15.0
            layer.borderWidth = 1.0
            layer.borderColor = UIColor.black.cgColor
            layer.masksToBounds = true
        }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
