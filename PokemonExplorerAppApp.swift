//
//  PokemonExplorerAppApp.swift
//  PokemonExplorerApp
//
//  Created by Matheus Braschi Haliski on 10/06/25.
//

import SwiftUI

@main
struct PokemonExplorerApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject private var authViewModel = AuthViewModel()

        var body: some Scene {
            WindowGroup {
                if authViewModel.isAuthenticated {
                    PokemonListViewModelWrapper()
                        .environmentObject(authViewModel)
                } else {
                    ContentView()
                        .environmentObject(authViewModel)
                }
            }
        }
}
