//
//  NetworkManager.swift
//  weatherNew
//
//  Created by Kirill Atrakhimovich on 20.10.21.
//

import Foundation

class NetworkManager {
   
    let apiKey = "17825af8d9109fb3a0f50dc6760f0c46"
    let stringURL = "http://api.openweathermap.org/data/2.5/forecast"

    func getWeatherData(city: String, completion: @escaping ((WeatherData) -> Void)) {
        
        let cityParam = "?q=\(city)"
        let apiKeyParam = "&appid=\(apiKey)"
        let completeURLString = "\(stringURL)\(cityParam)\(apiKeyParam)"
        
        parsingWeatherData(completeURLString: completeURLString, completion: completion)
    }
    
    func getWeatherData(lon: String, lat: String, completion: @escaping ((WeatherData) -> Void)) {
        let apiKeyParam = "&appid=\(apiKey)"
        let locationParam = "?lat=\(lat)&lon=\(lon)"
        let completeURLString = "\(stringURL)\(locationParam)\(apiKeyParam)"
        
        parsingWeatherData(completeURLString: completeURLString, completion: completion)
    }
    
    private func parsingWeatherData(completeURLString: String, completion: @escaping ((WeatherData) -> Void)) {
    
        guard let url = URL(string: completeURLString) else {
            print("Invalid url")
            return
        }
        
        let request = URLRequest(url: url)

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }

            guard let data = data else {
                print("No data in response")
                return
            }

            if let weatherData = try? JSONDecoder().decode(WeatherData.self, from: data) {
                completion(weatherData)
            }
                
        }.resume()
    }
}
