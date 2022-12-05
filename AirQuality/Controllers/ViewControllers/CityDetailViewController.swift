//
//  CityDetailViewController.swift
//  AirQuality
//
//  Created by Kvng Eko on 12/4/22.
//

import UIKit

class CityDetailViewController: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var cityStateCountryLabel: UILabel!
    @IBOutlet weak var aqiLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var latLongLabel: UILabel!
    
    
    
    //MARK: - Properties
    
    var country: String?
    var state: String?
    var city: String?
    
    
    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCityDetail()
        
    }
    
    //MARK: - Helper Methods
    
    func fetchCityDetail() {
        guard let city = city,
              let state = state,
              let country = country else {return}
        AirQualityController.fetchData(forCity: city, inState: state, inCountry: country) { result in
            DispatchQueue.main.async {
                switch result {
                    
                case .success(let cityData):
                    self.updateViews(with: cityData)
                case .failure(let error):
                    print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                }
            }
        }
        
    }
    
    func updateViews(with cityData: CityData) {
        let data = cityData.data
        
        cityStateCountryLabel.text = " \(data.city), \(data.state), \(data.country)"
        
        aqiLabel.text = "AQI: \(data.current.pollution.aqius)"
        
        windSpeedLabel.text = "Windspeed: \(data.current.weather.ws)"
        
        tempLabel.text = "Temperature: \(data.current.weather.tp)"
        
        humidityLabel.text = "Humidity: \(data.current.weather.hu)"
        
        let coordinates = data.location.coordinates
        if coordinates.count == 2 {
            latLongLabel.text = " Latitude: \(coordinates[1]) \nLongitude: \(coordinates[0])"
        } else {
            latLongLabel.text = "Coordinates Unknown"
        }
    }
    
}
