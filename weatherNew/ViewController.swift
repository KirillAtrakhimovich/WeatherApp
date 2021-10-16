//
//  ViewController.swift
//  weatherNew
//
//  Created by Kirill Atrakhimovich on 11.07.21.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var tableView: UITableView!
 
    @IBOutlet weak var textField: UITextField!
    var lists: [List] = []
 
    let locationManager = CLLocationManager()
    
    var currentLocation: CLLocation?
    
    @IBOutlet weak var textLabel: UILabel!
    let urlStringLondon = "http://api.openweathermap.org/data/2.5/forecast?q=Vitebsk&appid=17825af8d9109fb3a0f50dc6760f0c46"
    let urlStringMoscow = "http://api.openweathermap.org/data/2.5/forecast?q=Moscow&appid=17825af8d9109fb3a0f50dc6760f0c46"
    let urlStringTokyo = "http://api.openweathermap.org/data/2.5/forecast?q=Tokyo&appid=17825af8d9109fb3a0f50dc6760f0c46"
    let urlStringPekin = "http://api.openweathermap.org/data/2.5/forecast?q=Beijing&appid=17825af8d9109fb3a0f50dc6760f0c46"
    let urlStringMinsk = "http://api.openweathermap.org/data/2.5/forecast?q=Minsk&appid=17825af8d9109fb3a0f50dc6760f0c46"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
       
        let nib = UINib(nibName: WeatherTableViewCell.identifier, bundle: nil)
//        tableView.register(HourlyTableViewCell.nib(), forCellReuseIdentifier: WeatherTableViewCell.identifier)
        tableView.register(nib, forCellReuseIdentifier: WeatherTableViewCell.identifier)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        setupLocation()
    }
    
    func setupLocation(){
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty, currentLocation == nil {
            currentLocation = locations.first
            locationManager.stopUpdatingLocation()
            requestWeatherForLocation()
        }
    }
    
    func requestWeatherForLocation() {
        guard let currentLocation = currentLocation else {
            return
        }
        let long = currentLocation.coordinate.longitude
        let lat = currentLocation.coordinate.latitude

        print("\(long), \(lat)")
    }
    
    @IBAction func resultButtonPressed(_ sender: Any) {
        
        let name = textField.text
        
        let urlString = "http://api.openweathermap.org/data/2.5/forecast?q=\( name ?? "")&appid=17825af8d9109fb3a0f50dc6760f0c46"

        
        guard let url = URL(string: urlString) else {
            print("Invalid url")
            return
        }
        
        let request = URLRequest(url: url)

       
        
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
          
            guard let data = data else {
                print("No data in response")
                return
            }
            
            if let weatherData = try? JSONDecoder().decode(WeatherData.self, from: data) {
                self.lists = weatherData.list
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            }
            
        }
        task.resume()
     
    }
    
}

extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.identifier, for: indexPath) as? WeatherTableViewCell else {
            return UITableViewCell()
        }
        
        cell.tempLabel.text = "\((round(lists[indexPath.row].main.temp - 273)))°С"
        cell.imageWeather.image = UIImage(named:  lists[indexPath.row].weather.first?.icon ?? "01d")
        cell.dateLabel.text = "\(lists[indexPath.row].dt_txt)"

        tableView.numberOfRows(inSection: 0)
        textLabel.text = "\(lists[indexPath.row].weather.first?.main ?? "")"
        return cell
        


    }

    
}
