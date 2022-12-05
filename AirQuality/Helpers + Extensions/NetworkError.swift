//
//  NetworkError.swift
//  AirQuality
//
//  Created by Kvng Eko on 12/2/22.
//

import Foundation


enum NetworkError: LocalizedError {
    case invalidURL
    case thrownError(Error)
    case noData
    case unableToDecode
    
    var errorDescription: String? {
        switch self {
            
        case .invalidURL:
            return "Unable to reach the server due to a bad URL"
        case .thrownError(let error):
            return "Error: \(error.localizedDescription) -- \(error)"
        case .noData:
            return "The Server responded with no data"
        case .unableToDecode:
            return "There was an error trying to decode the data"
        }
        
    }
}
