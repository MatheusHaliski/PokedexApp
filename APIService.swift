//
//  APIService.swift
//  IOSPokedex
//
//  Created by Matheus Braschi Haliski on 06/06/25.
//

import Foundation


final class APIService {
    static let shared = APIService()
    private let baseURL = "https://pokeapi.co/api/v2/"
    
    func fetchPokemonList(completion: @escaping (Result<[Pokemon], Error>) -> Void) {
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=10")!
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else { return }
            do {
                let result = try JSONDecoder().decode(PokemonListResponse.self, from: data)
                let group = DispatchGroup()
                var pokemonList: [Pokemon] = []
                
                result.results.forEach { item in
                    group.enter()
                    self.fetchPokemonDetails(url: item.url) { result in
                        if case .success(let pokemon) = result {
                            pokemonList.append(pokemon)
                        }
                        group.leave()
                    }
                }
                
                group.notify(queue: .main) {
                    completion(.success(pokemonList))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func fetchPokemonDetails(url: String, completion: @escaping (Result<Pokemon, Error>) -> Void) {
        guard let detailURL = URL(string: url) else { return }
        URLSession.shared.dataTask(with: detailURL) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else { return }
            do {
                let pokemon = try JSONDecoder().decode(Pokemon.self, from: data)
                completion(.success(pokemon))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    struct PokemonListResponse: Codable {
        let results: [PokemonListItem]
    }

    struct PokemonListItem: Codable {
        let name: String
        let url: String
    }

}

