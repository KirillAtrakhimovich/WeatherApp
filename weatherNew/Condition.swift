//
//  Weather.swift
//  weatherNew
//
//  Created by Kirill Atrakhimovich on 11.07.21.
//

import Foundation

struct WeatherData: Codable{
    let list: [WeatherElement]
}
struct WeatherElement: Codable {
    let main: DetailedWeatherInfo
    let weather: [Condition]
    var dt_txt: String
    let wind: Wind
}
struct DetailedWeatherInfo: Codable {
    let temp: Float
    let temp_max: Float
    let temp_min: Float
    let feels_like: Float
    let humidity: Float
}
struct Condition: Codable {
    let main: String
    let description: String
    let icon: String
}
struct Wind: Codable {
    let speed: Float
    let deg: Float
}



