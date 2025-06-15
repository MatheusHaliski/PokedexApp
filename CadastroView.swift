//
//  CadastroView.swift
//  PokemonExplorerApp
//
//  Created by Matheus Braschi Haliski on 10/06/25.
//


//
//  CadastroView.swift
//  IOSPokedex
//
//  Created by Matheus Braschi Haliski on 06/06/25.
//

import SwiftUI

struct CadastroView: View {
    @Environment(\.dismiss) var dismiss
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""

    private let authService = AuthService()

    var body: some View {
        VStack(spacing: 20) {
            Text("Cadastro")
                .font(.largeTitle)
                .bold()

            TextField("Username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            Button("Registrar") {
                if username.isEmpty || password.isEmpty {
                    alertMessage = "Por favor, preencha todos os campos."
                    showAlert = true
                    return
                }

                let registered = authService.register(username: username, password: password)
                if registered {
                    alertMessage = "Usuário cadastrado com sucesso!"
                    showAlert = true
                    // Dismiss a tela de cadastro após 1.5 segundos
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        dismiss()
                    }
                } else {
                    alertMessage = "Nome de usuário já existe. Escolha outro."
                    showAlert = true
                }
            }
            .padding()

            Spacer()
        }
        .padding()
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Cadastro"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
}

#Preview {
    CadastroView()
}
