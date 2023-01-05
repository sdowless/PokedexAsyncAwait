//
//  PokedexViewModel.swift
//  PokedexAsyncAwait
//
//  Created by Stephan Dowless on 1/4/23.
//

import Foundation

enum PokedexServiceConfiguration {
    case urlSession
    case asyncAwait
}

class PokedexViewModel: ObservableObject {
    @Published var pokemon = [Pokemon]()
    @Published var error: Error?
    
    private let limit = 20
    private var offset = 0
    
    private var urlString: String {
        return "https://pokeapi.co/api/v2/pokemon/?limit=\(limit)&offset=\(offset)"
    }
    
    init(serviceConfig: PokedexServiceConfiguration) {
        switch serviceConfig {
        case .urlSession:
            fetchPokemonWithURLSession()
        case .asyncAwait:
            loadDataAsync()
        }
    }
}

// MARK: - Async Await

extension PokedexViewModel {
    @MainActor
    func fetchPokemonAsync() async throws {
        offset += pokemon.count

        do {
            guard let url = URL(string: urlString) else { throw PokedexError.invalidURL }
            let (data, response) = try await URLSession.shared.data(from: url)
            guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw PokedexError.serverError }
            guard let response = try? JSONDecoder().decode(PokemonResponse.self, from: data) else { throw PokedexError.invalidData }
            pokemon.append(contentsOf: response.results)
        } catch {
            self.error = error
        }
    }
    
    func loadDataAsync() {
        Task(priority: .medium) {
            try await fetchPokemonAsync()
        }
    }
}

// MARK: - URLSession

extension PokedexViewModel {
    func fetchPokemonWithURLSession() {
        guard let url = URL(string: urlString) else {
            self.error = PokedexError.invalidURL
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
                        
            DispatchQueue.main.async {
                if let error = error {
                    self.error = PokedexError.unkown(error)
                    return
                }
                
                guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                    self.error = PokedexError.serverError
                    return
                }
                
                guard let data = data else {
                    self.error = PokedexError.invalidData
                    return
                }
                
                guard let pokemonResponse = try? JSONDecoder().decode(PokemonResponse.self, from: data) else {
                    self.error = PokedexError.invalidData
                    return
                }
                            
                self.pokemon = pokemonResponse.results
            }
        }.resume()
    }
}
