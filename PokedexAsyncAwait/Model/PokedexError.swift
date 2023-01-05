//
//  PokedexError.swift
//  PokedexAsyncAwait
//
//  Created by Stephan Dowless on 1/4/23.
//

import Foundation

enum PokedexError: Error, LocalizedError {
    case invalidURL
    case serverError
    case invalidData
    case unkown(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return ""
        case .serverError:
            return "There was an error with the server. Please try again later"
        case .invalidData:
            return "The pokemon data is invalid. Please try again later"
        case .unkown(let error):
            return error.localizedDescription
        }
    }
}
