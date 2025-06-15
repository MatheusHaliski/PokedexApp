//
//  PokemonListViewModelWrapper.swift
//  PokemonExplorerApp
//
//  Created by Matheus Braschi Haliski on 10/06/25.
//

import SwiftUI

struct PokemonListViewModelWrapper: View {
    @StateObject private var viewModel = PokemonViewModel(userId: "")

    var body: some View {
        PokemonListView(viewModel: viewModel)
    }
}
