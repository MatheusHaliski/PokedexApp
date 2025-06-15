import SwiftUI
import CoreData

struct PokemonListView: View {
    @ObservedObject var viewModel: PokemonViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var favoriteIDs: Set<String> = []
    @Namespace private var animationNamespace
    private let context = PersistenceController.shared.container.viewContext
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        NavigationView {
            VStack {
                if let username = authViewModel.username, !username.isEmpty {
                    Text("Bem-vindo, \(username)!")
                        .font(.largeTitle)
                        .padding()
                }

                if viewModel.isLoading {
                    ProgressView()
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(viewModel.pokemons) { pokemon in
                                PokemonCell(
                                    pokemon: pokemon,
                                    isFavorite: favoriteIDs.contains(pokemon.name),
                                    toggleFavorite: toggleFavorite,
                                    animationNamespace: animationNamespace
                                )
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Pokémon List")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        authViewModel.logout()
                    }) {
                        Text("Sair")
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        NavigationLink(
                            destination: FavoriteView(viewModel: viewModel)
                                .environmentObject(authViewModel)
                        ) {
                            Text("Ver Favoritos")
                                .padding(8)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }




                        NavigationLink(destination: EditProfileView().environmentObject(authViewModel)) {
                            Text("Editar Perfil")
                        }
                    }
                }
            }
            .onAppear {
                viewModel.fetchPokemons()
                authViewModel.loadCurrentUser()
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }


    private func toggleFavorite(_ pokemon: Pokemon) {
        // 1️⃣ Obtém o usuário logado
        guard let userId = authViewModel.loadCurrentUser() else {
            print("Usuário não logado.")
            return
        }
        
        // 2️⃣ Alterna no array local para refletir o estado visual
        if favoriteIDs.contains(pokemon.name) {
            favoriteIDs.remove(pokemon.name)
        } else {
            favoriteIDs.insert(pokemon.name)
        }
        
        // 3️⃣ Busca no CoreData por favorito do usuário logado
        let request: NSFetchRequest<Favorite> = Favorite.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d AND userId == %@", pokemon.id, userId as! CVarArg)
        
        do {
            let results = try context.fetch(request)
            if let existingFavorite = results.first {
                // 4️⃣ Se existir, remove
                context.delete(existingFavorite)
                print("Removido dos favoritos: \(existingFavorite.name ?? "Sem Nome")")
            } else {
                // 5️⃣ Se não existir, adiciona
                let newFavorite = Favorite(context: context)
                newFavorite.id = Int32(pokemon.id)
                newFavorite.name = pokemon.name
                newFavorite.imageUrl = pokemon.sprites.frontDefault ?? ""
                newFavorite.userId = userId  // associar ao usuário logado
                print("Adicionado aos favoritos: \(pokemon.name)")
            }
            try context.save()
            
            // 6️⃣ Atualiza a lista de favoritos do usuário logado
            viewModel.fetchFavorites(for: userId)
        } catch {
            print("Erro ao alternar favorito: \(error)")
        }
    }

}

