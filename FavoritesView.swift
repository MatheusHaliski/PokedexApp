import SwiftUICore
import SwiftUI
struct FavoriteView: View {
    @ObservedObject var viewModel: PokemonViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        List(viewModel.favorites, id: \.id) { favorite in
            HStack {
                if let urlString = favorite.imageUrl,
                   let url = URL(string: urlString) {
                    AsyncImage(url: url) { image in
                        image.resizable()
                             .scaledToFit()
                             .frame(width: 50, height: 50)
                    } placeholder: {
                        ProgressView()
                    }
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.gray)
                }

                VStack(alignment: .leading) {
                    Text(favorite.name ?? "Sem Nome")
                        .font(.headline)
                    Text("ID: \(favorite.id)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.vertical, 8)
        }
        .onAppear {
            if let userId = authViewModel.loadCurrentUser(){
                viewModel.fetchFavorites(for: userId)
            }
        }
    }
}

