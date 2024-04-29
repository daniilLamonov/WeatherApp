//
//  ViewController.swift
//  WeatherApp
//
//  Created by Danil Lamonov on 22.04.2024.
//

import UIKit
import SpringAnimation

class ViewController: UIViewController {
    private var city = "City"
    private let mainView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "main")
        return view
    }()
    private lazy var windLabel: UILabel = {
        let label = UILabel()
        label.text = "wind"
        label.font = UIFont(name: "Copperplate", size: 20)
        label.tintColor = .black
        label.backgroundColor = .clear
        label.textAlignment = .center
        return label
    }()
    private lazy var skyLabel: UILabel = {
        let label = UILabel()
        label.text = "Description"
        label.font = UIFont(name: "Copperplate", size: 20)
        label.tintColor = .black
        label.backgroundColor = .clear
        label.textAlignment = .center
        return label
    }()
    private lazy var forecastFirstDay: UILabel = {
        let label = UILabel()
        label.text = "First"
        label.font = UIFont(name: "Copperplate", size: 18)
        label.tintColor = .black
        label.backgroundColor = .clear
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    private lazy var forecastSecondDay: UILabel = {
        let label = UILabel()
        label.text = "Second"
        label.font = UIFont(name: "Copperplate", size: 18)
        label.tintColor = .black
        label.backgroundColor = .clear
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    private lazy var cityButton: SpringButton = {
        let button = SpringButton(primaryAction: btnPressed)
        button.backgroundColor = .white
        button.setTitle("City", for: .normal)
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        button.layer.cornerRadius = 20
        button.layer.shadowColor = UIColor.white.cgColor
        button.layer.shadowRadius = 10
        button.layer.shadowOpacity = 0.5
        return button
    }()
    private let temperature: UILabel = {
        let label = UILabel()
        label.text = "0°C"
        label.font = UIFont(name: "Copperplate", size: 60)
        label.tintColor = .black
        label.backgroundColor = .clear
        label.textAlignment = .center
        return label
    }()
    private let cityLabel: UILabel = {
        let label = UILabel()
        label.text = "City"
        label.font = UIFont(name: "Copperplate", size: 40)
        label.tintColor = .black
        label.backgroundColor = .clear
        label.textAlignment = .center
        return label
    }()
    private var apiManager = APIManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        setConstraints()
    }
    func updateInterface(weather: Weather?) {
        DispatchQueue.main.async {
            let temperatureInCity = weather?.temperature
            let windInCity = weather?.wind
            let sky = weather?.description
            guard let temperatureInCity, let windInCity, let sky else {return}
            self.skyLabel.text = sky
            self.temperature.text = temperatureInCity
            self .windLabel.text = windInCity
            weather?.forecast?.forEach() {day in
                switch day.day! {
                case "1":
                    self.forecastFirstDay.text = """
                    Tomorrow
                    \(day.temperature ?? "none")
                    """
                case "2":
                    self.forecastSecondDay.text = """
                    After tomorrow 
                    \(day.temperature ?? "none")
                    """
                default:
                    return
                }
            }
        }
    }
    private lazy var btnPressed = UIAction { _ in
        self.presentSearchAlertController(withTitle: "Enter city name", message: nil, style: .alert) { [unowned self] city in
            self.cityButton.setTitle(city, for: .normal)
            self.apiManager.fetchWeather(city: city)
            self.apiManager.onCompletion = { [weak self] currentWeather in
                guard let self = self else {return}
                guard let currentWeather else {return}
                print(currentWeather)
                updateInterface(weather: currentWeather)
            }
        }
        self.cityButton.animation = "pop"
        self.cityButton.animate()
    }
    private func setConstraints(){
        view.addSubview(mainView)
        view.addSubview(cityButton)
        mainView.addSubview(temperature)
        mainView.addSubview(windLabel)
        mainView.addSubview(skyLabel)
        mainView.addSubview(forecastFirstDay)
        mainView.addSubview(forecastSecondDay)
        [mainView, windLabel, temperature, cityButton, skyLabel, forecastFirstDay, forecastSecondDay].forEach { ui in
            ui.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            windLabel.topAnchor.constraint(equalTo: temperature.topAnchor, constant: 50),
            windLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            windLabel.heightAnchor.constraint(equalToConstant: 30),
            windLabel.widthAnchor.constraint(equalToConstant: 100)
        ])
        NSLayoutConstraint.activate([
            skyLabel.topAnchor.constraint(equalTo: windLabel.topAnchor, constant: 30),
            skyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            skyLabel.heightAnchor.constraint(equalToConstant: 30),
            skyLabel.widthAnchor.constraint(equalToConstant: 200)
        ])
        NSLayoutConstraint.activate([
            forecastFirstDay.topAnchor.constraint(equalTo: skyLabel.topAnchor, constant: 50),
            forecastFirstDay.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            forecastFirstDay.heightAnchor.constraint(equalToConstant: 100),
            forecastFirstDay.widthAnchor.constraint(equalToConstant: 150)
        ])
        
        NSLayoutConstraint.activate([
            forecastSecondDay.topAnchor.constraint(equalTo: skyLabel.topAnchor, constant: 50),
            forecastSecondDay.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            forecastSecondDay.heightAnchor.constraint(equalToConstant: 100),
            forecastSecondDay.widthAnchor.constraint(equalToConstant: 150)
        ])
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: view.topAnchor),
            mainView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mainView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        NSLayoutConstraint.activate([
            temperature.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            temperature.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        NSLayoutConstraint.activate([
            cityButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cityButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30),
            cityButton.heightAnchor.constraint(equalToConstant: 50),
            cityButton.widthAnchor.constraint(equalToConstant: 300)
        ])
        
    }
    func presentSearchAlertController(withTitle title: String?, message: String?, style: UIAlertController.Style, completionHandler: @escaping(String) -> Void) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: style)
        ac.addTextField { tf in
            let cities = "Enter your city"
            tf.placeholder = cities
        }
        let search = UIAlertAction(title: "Search", style: .default) { action in
            let textField = ac.textFields?.first
            guard let cityName = textField?.text else { return }
            if cityName != "" {
                let city = cityName.split(separator: " ").joined(separator: "%20")
                completionHandler(city)
            }
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        ac.addAction(search)
        ac.addAction(cancel)
        present(ac, animated: true, completion: nil)
    }
}
