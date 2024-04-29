//
//  Weater.swift
//  WeatherApp
//
//  Created by Danil Lamonov on 24.04.2024.
//

import Foundation

// MARK: - Weather
struct Weather: Codable {
    let temperature, wind, description: String?
    let forecast: [Forecast]?
}

// MARK: - Forecast
struct Forecast: Codable {
    let day, temperature, wind: String?
}
