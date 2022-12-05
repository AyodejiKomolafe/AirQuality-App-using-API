//
//  AirQualityController.swift
//  AirQuality
//
//  Created by Kvng Eko on 12/1/22.
//

import Foundation


class AirQualityController{
    static let baseURL = URL(string: "https://api.airvisual.com/")
    static let versionComponent = "v2"
    static let countriesComponent = "countries"
    static let statesComponent = "states"
    static let citiesComponent = "cities"
    static let cityComponent = "city"
    
    static let countryKey = "country"
    static let stateKey = "state"
    static let cityKey = "city"
    
    static let apiKeyKey = "key"
    static let apiKeyValue = "66ac6c42-d4ce-46aa-9715-cc731ce49d8c"
    
    //66ac6c42-d4ce-46aa-9715-cc731ce49d8c
    
    //http://api.airvisual.com/v2/countries?key={{YOUR_API_KEY}}
    //fetch countries
    
    static func fetchCountries(completion: @escaping (Result<[String], NetworkError>) -> Void) {
        guard let baseURL = baseURL else {return completion(.failure(.invalidURL))}
        let versionURL = baseURL.appendingPathComponent(versionComponent)
        let countriesURL = versionURL.appendingPathComponent(countriesComponent)
        
        var components = URLComponents(url: countriesURL, resolvingAgainstBaseURL: true)
        let apiQuery = URLQueryItem(name: apiKeyKey, value: apiKeyValue)
        components?.queryItems = [apiQuery]
        
        guard let finalURL = components?.url else {return completion(.failure(.invalidURL))}
        
        print(finalURL)
        
        URLSession.shared.dataTask(with: finalURL) { data, _, error in
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            
            guard let data = data else {return completion(.failure(.noData))}
            
            do {
                let topLevelObject = try JSONDecoder().decode(Country.self, from: data)
                let countryDicts = topLevelObject.data
                
                var listOfCountryNames: [String] = []
                
                for country in countryDicts {
                    let countryName = country.countryName
                    listOfCountryNames.append(countryName)
                }
                return completion(.success(listOfCountryNames))
                
            } catch {
                return completion(.failure(.unableToDecode))
            }
            
            
            
            
            
        }.resume()
    }
    
    
    //http://api.airvisual.com/v2/states?country={{COUNTRY_NAME}}&key={{YOUR_API_KEY}}
    //fetch states
    
    static func fetchStates(forCountry: String, completion: @escaping (Result<[String], NetworkError>) -> Void) {
        guard let baseURL = baseURL else {return completion(.failure(.invalidURL))}
        let versionURL = baseURL.appendingPathComponent(versionComponent)
        let statesURL = versionURL.appendingPathComponent(statesComponent)
        
        var components = URLComponents(url: statesURL, resolvingAgainstBaseURL: true)
        let countryQuery = URLQueryItem(name: countryKey, value: forCountry)
        let apiQuery = URLQueryItem(name: apiKeyKey, value: apiKeyValue)
        components?.queryItems = [countryQuery,apiQuery]
        
        
        guard let finalUrl = components?.url else {return completion(.failure(.invalidURL))}
        print(finalUrl)
        URLSession.shared.dataTask(with: finalUrl) { data, _, error in
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            
            guard let data = data else {return completion(.failure(.noData))}
            
            do {
                let topLevelObject = try JSONDecoder().decode(State.self, from: data)
                let stateDicts = topLevelObject.data
                
                var listOfStateNames: [String] = []
                
                for state in stateDicts {
                    let stateName = state.stateName
                    listOfStateNames.append(stateName)
                }
                return completion(.success(listOfStateNames))
                
            } catch {
                return completion(.failure(.unableToDecode))
            }
            
            
            
            
            
        }.resume()
    }
    
    //http://api.airvisual.com/v2/cities?state={{STATE_NAME}}&country={{COUNTRY_NAME}}&key={{YOUR_API_KEY}}
    //fetch cities
    static func fetchCities(forState: String, incCountry: String, completion: @escaping (Result<[String], NetworkError>) -> Void) {
        guard let baseURL = baseURL else {return completion(.failure(.invalidURL))}
        let versionURL = baseURL.appendingPathComponent(versionComponent)
        let citiesURL = versionURL.appendingPathComponent(citiesComponent)
        
        var components = URLComponents(url: citiesURL, resolvingAgainstBaseURL: true)
        let stateQuery = URLQueryItem(name: stateKey, value: forState)
        let countryQuery = URLQueryItem(name: countryKey, value: incCountry)
        let apiQuery = URLQueryItem(name: apiKeyKey, value: apiKeyValue)
        
        components?.queryItems = [stateQuery, countryQuery, apiQuery]
        
        guard let finalURL = components?.url else { return completion(.failure(.invalidURL)) }
        print(finalURL)
        
        URLSession.shared.dataTask(with: finalURL) { data, _, error in
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            guard let data = data else {return completion(.failure(.noData))}
            
            do {
                let topLevelObject = try JSONDecoder().decode(City.self, from: data)
                let cityDicts = topLevelObject.data
                
                var listOfCityNames: [String] = []
                
                for city in cityDicts {
                    let cityName = city.cityName
                    listOfCityNames.append(cityName)
                }
                
                return completion(.success(listOfCityNames))
                
            } catch {
                return completion(.failure(.unableToDecode))
            }
            
        }.resume()
    }
    
    //http://api.airvisual.com/v2/city?city={{CITY_NAME}}&state={{STATE_NAME}}&country={{COUNTRY_NAME}}&key={{YOUR_API_KEY}}
    //fetch city data
    static func fetchData(forCity: String, inState: String, inCountry: String, completion: @escaping (Result<CityData, NetworkError>) -> Void){
        guard let baseURL = baseURL else {return completion(.failure(.invalidURL))}
        let versionURL = baseURL.appendingPathComponent(versionComponent)
        let cityURL = versionURL.appendingPathComponent(cityComponent)
        
        var components = URLComponents(url: cityURL, resolvingAgainstBaseURL: true)
        let cityQuery = URLQueryItem(name: cityKey, value: forCity)
        let stateQuery = URLQueryItem(name: stateKey, value: inState)
        let countryQuery = URLQueryItem(name: countryKey, value: inCountry)
        let apiQuery = URLQueryItem(name: apiKeyKey, value: apiKeyValue)
        components?.queryItems = [cityQuery,stateQuery,countryQuery,apiQuery]
        
        guard let finalURL = components?.url else {return completion(.failure(.invalidURL))}
        
        print(finalURL)
        
        URLSession.shared.dataTask(with: finalURL) { data, _, error in
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            
            guard let data = data else {return completion(.failure(.noData))}
            do {
                let cityData = try JSONDecoder().decode(CityData.self, from: data)
                return completion(.success(cityData))
            } catch {
                return completion(.failure(.unableToDecode))
            }
        }.resume()
        
        
    }
    
    
    
}//End of class
