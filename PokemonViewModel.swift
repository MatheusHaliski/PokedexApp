//
//  PokemonViewModel.swift
//  PokemonExplorerApp
//
//  Created by Matheus Braschi Haliski on 10/06/25.
//

import Foundation
import CoreData


// MARK: - ViewModel

class PokemonViewModel: ObservableObject {
    @Published var userId: String
    @Published var pokemons: [Pokemon] = []
    @Published var favorites: [Favorite] = []
    @Published var isLoading = false
    private let apiURL = "https://pokeapi.co/api/v2/pokemon?limit=20"
    private let context = PersistenceController.shared.container.viewContext
    
 
    init(userId: String) {
           self.userId = userId
           checkFirstLaunch()
           fetchPokemons()
           fetchFavorites(for: userId)
       }
    func fetchPokemons() {
        guard let url = URL(string: apiURL) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            do {
                let decodedList = try JSONDecoder().decode(PokemonListResponse.self, from: data)
                let group = DispatchGroup()
                var fetchedPokemons: [Pokemon] = []
                
                for result in decodedList.results {
                    group.enter()
                    URLSession.shared.dataTask(with: URL(string: result.url)!) { detailData, _, _ in
                        if let detailData = detailData {
                            if let detailedPokemon = try? JSONDecoder().decode(Pokemon.self, from: detailData) {
                                DispatchQueue.main.async {
                                    fetchedPokemons.append(detailedPokemon)
                                }
                            }
                        }
                        group.leave()
                    }.resume()
                }
                group.notify(queue: .main) {
                    self.pokemons = fetchedPokemons.sorted { $0.id < $1.id }
                }
            } catch {
                print("Decoding Error: \(error)")
            }
        }.resume()
    }
    
    func toggleFavorite1(for pokemon: Pokemon) {
        let request: NSFetchRequest<Favorite> = Favorite.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", pokemon.id)
        
        do {
            let results = try context.fetch(request)
            if let existingFavorite = results.first {
                context.delete(existingFavorite)
                print("Removido dos favoritos: \(existingFavorite.name ?? "Sem Nome")")
            } else {
                let newFavorite = Favorite(context: context)
                newFavorite.id = Int32(pokemon.id)
                newFavorite.name = pokemon.name
                newFavorite.imageUrl = pokemon.sprites.frontDefault ?? ""
                print("Adicionado aos favoritos: \(pokemon.name)")
            }
            try context.save()
            fetchFavorites(for: userId)
        } catch {
            print("Erro ao alternar favorito: \(error)")
        }
    }
    
    
    
    // API Response for List
    struct PokemonListResponse: Codable {
        let results: [PokemonListItem]
    }
    
    struct PokemonListItem: Codable {
        let name: String
        let url: String
    }
    
    
    func fetchFavorites(for userId: String) {
        let request: NSFetchRequest<Favorite> = Favorite.fetchRequest()
        request.predicate = NSPredicate(format: "userId == %@", userId)
        
        do {
            let fetchedFavorites = try context.fetch(request)
            DispatchQueue.main.async {
                self.favorites = fetchedFavorites
            }
            print("Favoritos carregados para usuário \(userId): \(fetchedFavorites.count)")
        } catch {
            print("Erro ao buscar favoritos: \(error)")
        }
    }

    
    
    func clearFavorites() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Favorite.fetchRequest()
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(batchDeleteRequest)
            try context.save()
            print("Favorites cleared successfully")
        } catch {
            print("Failed to clear favorites: \(error)")
        }
    }

    
    func checkFirstLaunch() {
        let isFirstLaunch = !UserDefaults.standard.bool(forKey: "hasLaunchedBefore")
        if isFirstLaunch {
            clearFavorites()
            UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
        }
    }

}
