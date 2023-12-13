//
//  HourlyForecastCollectionView.swift
//  weatherApp
//
//  Created by Pavel Shymanski on 10.12.23.
//

import UIKit

class HourlyForecastCollectionView: UICollectionView  {
    
    let cellIdentifier = "HourlyCollectionViewCell"
    var cells : [HourlyWeatherToShow] = []
    
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        super.init(frame: .zero, collectionViewLayout: layout)
        delegate = self
        dataSource = self
        let nibCell = UINib(nibName: "HourlyCollectionViewCell", bundle: nil)
        register(nibCell, forCellWithReuseIdentifier: cellIdentifier)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension HourlyForecastCollectionView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cells.isEmpty ? 0 : cells.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? HourlyCollectionViewCell
        cell?.hourLabel.text = cells[indexPath.row].hour
        cell?.temperatureLabel.text = cells[indexPath.row].temperatureString
        cell?.iconWeatherImage.image = UIImage(named: cells[indexPath.row].weatherImage )
        
        return cell!
    }
}

extension HourlyForecastCollectionView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
}


