//
//  DailyForecastTableView.swift
//  weatherApp
//
//  Created by Pavel Shymanski on 14.12.23.
//

import UIKit

class DailyForecastTableView: UITableView  {
    
    var cells: [DailyWeatherToShow] = []
    let identifier = "DailyTableViewCell"
    
    init() {
        super.init(frame: .zero, style: .plain)
        delegate = self
        dataSource = self
        let nibCell = UINib(nibName: "DailyTableViewCell", bundle: nil)
        register(nibCell, forCellReuseIdentifier: identifier)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension DailyForecastTableView: UITableViewDelegate, UITableViewDataSource  {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.isEmpty ? 0 : cells.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? DailyTableViewCell
        cell?.weekDayLabel.text = cells[indexPath.row].day
        cell?.temperatureLabel.text = cells[indexPath.row].temperatureString + "°"
        cell?.iconWeatherImage.image = UIImage(named: cells[indexPath.row].weatherImage)
        
        return cell!
    }
    
    
}
