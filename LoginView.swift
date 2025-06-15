import SwiftUICore
import SwiftUI

struct LoginView: View {
    @StateObject private var authViewModel = AuthViewModel()
    @State private var usernameInput: String = ""
    @State private var passwordInput: String = ""
    @State private var animateLogin = false
    @State private var animateRegister = false
    
    // LazyHGrid com duas colunas
    private let gridItems = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationView {
            VStack(spacing: DesignTokens2.padding) {
                // Título
                Text("Login")
                    .font(DesignTokens2.titleFont)
                    .foregroundColor(DesignTokens.primaryColor)
                    .padding(.top, DesignTokens2.padding)
                
                // Campos de Login usando LazyHGrid
                LazyHGrid(rows: [GridItem(.fixed(60))], spacing: DesignTokens2.padding) {
                    Group {
                        TextField("Username", text: $usernameInput)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 150)
                            .padding(.horizontal, 5)
                        
                        SecureField("Password", text: $passwordInput)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 150)
                            .padding(.horizontal, 5)
                    }
                }
                .padding(.horizontal, DesignTokens2.padding)
                
                Button(action: {
                    guard !usernameInput.isEmpty, !passwordInput.isEmpty else {
                        // Opcional: exibir um alerta ou feedback visual
                        print("Preencha todos os campos!")
                        return
                    }
                    withAnimation(.easeInOut(duration: 0.5)) {
                        animateLogin.toggle()
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        authViewModel.login(username: usernameInput, password: passwordInput)
                        authViewModel.saveCurrentUser(username: usernameInput)
                    }
                }) {
                    Text("Login")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(DesignTokens.primaryColor)
                        .cornerRadius(DesignTokens2.cornerRadius)
                        .scaleEffect(animateLogin ? 1.1 : 1.0)
                }
                .padding(.horizontal, DesignTokens2.padding)
                
                // Botão de Cadastro com animação
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        animateRegister.toggle()
                    }
                }) {
                    Text("Cadastrar")
                        .foregroundColor(DesignTokens.primaryColor)
                        .font(.headline)
                        .padding()
                        .scaleEffect(animateRegister ? 1.1 : 1.0)
                }
                .background(
                    NavigationLink(
                        destination: CadastroView(),
                        isActive: $animateRegister
                    ) {
                        EmptyView()
                    }
                )
                
                // Navegação programática para a PokemonListView quando autenticado
                NavigationLink(destination: PokemonListViewModelWrapper(),
                               isActive: $authViewModel.isAuthenticated) {
                    EmptyView()
                }
            }
            .padding()
            .background(Color(.systemGroupedBackground))
            .cornerRadius(DesignTokens2.cornerRadius)
            .shadow(radius: 5)
            .padding(.horizontal, DesignTokens2.padding)
            .onAppear {
                authViewModel.loadCurrentUser()
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .fullScreenCover(isPresented: $authViewModel.isAuthenticated) {
            PokemonListViewModelWrapper()

        }
    }
}


