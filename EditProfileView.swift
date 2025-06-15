//
//  EditProfileView.swift
//  PokemonExplorerApp
//
//  Created by Matheus Braschi Haliski on 10/06/25.
//

import SwiftUICore
import SwiftUI


struct EditProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var newUsername: String = ""
    @State private var showingAlert = false
    
    var body: some View {
        Form {
            Section(header: Text("Editar Nome de Usuário")) {
                TextField("Novo nome de usuário", text: $newUsername)
            }
            
            Button("Salvar") {
                if !newUsername.isEmpty {
                    authViewModel.saveCurrentUser(username: newUsername)
                    showingAlert = true
                }
            }
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Sucesso"), message: Text("Nome atualizado!"), dismissButton: .default(Text("OK")))
            }
        }
        .navigationTitle("Editar Perfil")
        .onAppear {
            newUsername = authViewModel.username ?? ""
        }
    }
}
