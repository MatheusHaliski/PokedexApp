import SwiftUI

struct ContentView: View {
    @State private var rotatePokeball = false
    @StateObject private var authViewModel = AuthViewModel()
    @StateObject private var pokemonViewModel: PokemonViewModel

    // MARK: - Inicializador
    init() {
        let savedUserId = UserDefaults.standard.string(forKey: "loggedInUsername") ?? ""
        _pokemonViewModel = StateObject(wrappedValue: PokemonViewModel(userId: savedUserId))
    }

    var body: some View {
        NavigationView {
            VStack {
                if !authViewModel.isAuthenticated {
                    Spacer()

                    // Pokébola Animada
                    Image("pokeball")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                        .rotationEffect(.degrees(rotatePokeball ? 360 : 0))
                        .animation(
                            .linear(duration: 3).repeatForever(autoreverses: false),
                            value: rotatePokeball
                        )
                        .onAppear {
                            rotatePokeball = true
                        }
                        .padding(.bottom, 20)

                    // Texto de boas-vindas
                    Text("Bem-vindo ao Pokedex! Acesse sua conta para continuar.")
                        .font(DesignTokens2.titleFont)
                        .foregroundColor(DesignTokens.primaryColor)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, DesignTokens2.padding)

                    Spacer()

                    // LoginView
                    LoginView()
                } else {
                    // Usuário autenticado, mostrar a lista de Pokémon
                    PokemonListView(viewModel: pokemonViewModel)
                }
            }
            .navigationTitle("")
            .navigationBarHidden(true)
            .environmentObject(authViewModel)
            .environmentObject(pokemonViewModel)
            .onChange(of: authViewModel.username) { newUserId in
                if let userId = newUserId {
                    pokemonViewModel.userId = userId
                    pokemonViewModel.fetchFavorites(for: userId)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}

