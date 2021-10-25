//
//  ViewController.swift
//  weatherNew
//
//  Created by Kirill Atrakhimovich on 11.07.21.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    var weatherElements: [WeatherElement] = []
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    let netwoorkManager = NetworkManager()
    var completion: ((WeatherData) -> Void)?
    var long = ""
    var lat = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundImage.image = UIImage(named: "background_image")
        setupCompletion()
        setupTableSettings()
        textField.delegate = self
        tableView.backgroundColor = .clear
        tableView.tableFooterView = UIView()
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        setupLocation()
        requestWeatherForLocation()
    }

    private func setupCompletion() {
        completion = { weatherData in
            self.weatherElements = weatherData.list
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private func setupTableSettings() {
        tableView.dataSource = self

        let nib = UINib(nibName: WeatherTableViewCell.identifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: WeatherTableViewCell.identifier)
    }
    
    private func setupLocation(){
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

    private func requestWeatherForLocation() {
        textField.text = "San Francisco"
        guard let currentLocation = currentLocation else {
            return
        }
        long = String(currentLocation.coordinate.longitude)
        lat = String(currentLocation.coordinate.latitude)
        updateWetherData(byCity: false)
    }

    @IBAction func resultButtonPressed(_ sender: Any) {
        updateWetherData(byCity: true)
    }
    
    private func updateWetherData(byCity: Bool) {
        if let name = textField.text,
           let completion = completion {
            switch byCity {
            case true:
                netwoorkManager.getWeatherData(city: name, completion: completion)
            default:
                netwoorkManager.getWeatherData(lon: long, lat: lat, completion: completion)
            }
        }
    }
}

extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherElements.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.identifier, for: indexPath) as? WeatherTableViewCell else {
            return UITableViewCell()
        }
       
        textLabel.text = "Humidity: \(weatherElements[indexPath.row].main.humidity)%  \nFeels like: \(round(weatherElements[indexPath.row].main.feels_like - 273))°С \nWind: \(weatherElements[indexPath.row].wind.speed) Mps "
        cell.backgroundColor = .clear
        cell.setupInfo(info: weatherElements[indexPath.row])
        return cell
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateWetherData(byCity: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.textField.resignFirstResponder()
        updateWetherData(byCity: true)
        return true
    }
}
