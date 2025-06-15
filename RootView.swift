import SwiftUICore
struct RootView: View {
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        if authViewModel.isAuthenticated {
            PokemonListViewModelWrapper()
                .environmentObject(authViewModel) 
        } else {
            ContentView() // sua tela de login
                .environmentObject(authViewModel)
        }
    }
}

