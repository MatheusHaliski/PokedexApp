//
//  PokemonDetailView.swift
//  PokemonExplorerApp
//
//  Created by Matheus Braschi Haliski on 10/06/25.
//


import SwiftUICore
import SwiftUI

struct PokemonDetailView: View {
    let pokemon: Pokemon
    let namespace: Namespace.ID
    
    // Layout de duas colunas
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: DesignTokens.padding) {
                // Nome do Pokémon
                Text(pokemon.name.capitalized)
                    .font(DesignTokens2.titleFont)
                    .foregroundColor(DesignTokens.primaryColor)
                    .padding(.top, DesignTokens.padding)
                
                VStack(spacing: DesignTokens2.padding) {
                    // Imagem principal com animação
                    AsyncImage(url: URL(string: pokemon.imageUrl)) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 150)
                            .clipShape(RoundedRectangle(cornerRadius: DesignTokens2.cornerRadius))
                            .shadow(radius: 5)
                            .matchedGeometryEffect(id: "sprite\(pokemon.id)", in: namespace)
                    } placeholder: {
                        ProgressView()
                            .frame(width: 150, height: 150)
                    }
                    
                    // Atributos usando LazyVGrid
                    LazyVGrid(columns: columns, alignment: .leading, spacing: 16) {
                        Group {
                            attributeItem(title: "Height", value: "\(pokemon.height)")
                            attributeItem(title: "Weight", value: "\(pokemon.weight)")
                            attributeItem(title: "Base XP", value: "\(pokemon.baseExperience)")
                            
                            if !pokemon.types.isEmpty {
                                attributeItem(title: "Types", value: pokemon.types.joined(separator: ", ").capitalized)
                            }
                            
                            // Adicione mais atributos aqui, se quiser
                        }
                    }
                }
                .padding(DesignTokens2.padding)
                .background(Color.white)
                .cornerRadius(DesignTokens2.cornerRadius)
                .shadow(color: .gray.opacity(0.3), radius: 8, x: 0, y: 4)
                .padding(.horizontal, DesignTokens2.padding)
            }
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle(pokemon.name.capitalized)
    }
    
    // MARK: - Helper para exibir cada atributo
    @ViewBuilder
    private func attributeItem(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            Text(value)
                .font(.headline)
                .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(8)
    }
}
