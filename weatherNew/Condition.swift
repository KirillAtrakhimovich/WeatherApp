//
//  Weather.swift
//  weatherNew
//
//  Created by Kirill Atrakhimovich on 11.07.21.
//

import Foundation

struct WeatherData: Codable{
    let list: [List]
}



struct Main: Codable {
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

struct List: Codable {
    let main: Main
    let weather: [Condition]
    let dt_txt: String
    let wind: Wind

}
struct Wind: Codable {
    let speed: Float
    let deg: Float
}



