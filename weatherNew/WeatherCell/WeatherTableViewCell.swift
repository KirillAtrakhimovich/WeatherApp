//
//  WeatherTableViewCell.swift
//  weatherNew
//
//  Created by Kirill Atrakhimovich on 25.08.21.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {
   
    static  let identifier = "WeatherTableViewCell"
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var imageWeather: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "WeatherTableViewCell", bundle: nil)
    }
    
    func setupInfo(info: WeatherElement) {
        tempLabel.text = "\((round(info.main.temp - 273)))°С"
        imageWeather.image = UIImage(named:  info.weather.first?.icon ?? "01d")
        dateLabel.text = getFormatedDate(dateString: info.dt_txt)
    }
    
    
    private func getFormatedDate(dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        if let newDate = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "MMM d, h:mm a"
            let stringDate = dateFormatter.string(from: newDate)
            return stringDate
        }
        return ""
    }

}
