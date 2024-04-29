//
//  APIManager.swift
//  WeatherApp
//
//  Created by Danil Lamonov on 22.04.2024.
//

import Foundation
import Alamofire

class APIManager {
    static let shared = APIManager()
    var onCompletion: ((Weather?) -> Void)?
    
    func fetchWeather(city: String){
        let url = "https://goweather.herokuapp.com/weather/\(city)"
        AF.request(url).validate().responseData{ dataResponse in
            switch dataResponse.result{
            case .success(let data):
                do{
                    let weather = try JSONDecoder().decode(Weather.self, from: data)
                    self.onCompletion?(weather)
                } catch let error{
                    print(error)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
 }
