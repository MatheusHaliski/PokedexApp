//
//  PokemonCell.swift
//  IOSPokedex
//
//  Created by Matheus Braschi Haliski on 09/06/25.
//

import SwiftUICore
import SwiftUI

struct PokemonCell: View {
    var pokemon: Pokemon
    var isFavorite: Bool
    var toggleFavorite: (Pokemon) -> Void
    var animationNamespace: Namespace.ID
    
    var body: some View {
        NavigationLink(destination: PokemonDetailView(pokemon: pokemon, namespace: animationNamespace)) {
            VStack {
                AsyncImage(url: URL(string: pokemon.imageUrl)) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: DesignTokens.imageSize, height: DesignTokens.imageSize)
                        .background(DesignTokens.backgroundColor)
                        .cornerRadius(DesignTokens.cornerRadius)
                        .matchedGeometryEffect(id: "sprite\(pokemon.id)", in: animationNamespace)
                } placeholder: {
                    ProgressView()
                        .frame(width: DesignTokens.imageSize, height: DesignTokens.imageSize)
                }
                
                Text(pokemon.name.capitalized)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Button(action: {
                    toggleFavorite(pokemon)
                }) {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .foregroundColor(.red)
                }
                .buttonStyle(BorderlessButtonStyle())
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(radius: 4)
        }
    }
}
