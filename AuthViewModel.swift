import Foundation
import CoreData

class AuthViewModel: ObservableObject {
    @Published var username: String? = nil
    @Published var isAuthenticated: Bool = false
    
    private let context = CoreDataStack.shared.context
    
    func login(username: String, password: String) {
        // Buscar usuário no CoreData
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "username == %@ AND password == %@", username, password)
        
        do {
            let users = try context.fetch(fetchRequest)
            if let _ = users.first {
                // Usuário autenticado com sucesso
                self.username = username
                self.isAuthenticated = true
                saveCurrentUser(username: username)
            } else {
                // Falha na autenticação
                self.isAuthenticated = false
                self.username = nil
            }
        } catch {
            print("Erro ao buscar usuário: \(error.localizedDescription)")
            self.isAuthenticated = false
            self.username = nil
        }
    }
    
    func loadCurrentUser() -> String? {
        if let savedUsername = UserDefaults.standard.string(forKey: "loggedInUsername") {
            self.username = savedUsername
            self.isAuthenticated = true
            return savedUsername
        }
        return nil
    }

    
    func saveCurrentUser(username: String) {
        // Atualiza UserDefaults
        UserDefaults.standard.set(username, forKey: "loggedInUsername")
        
        // Atualiza no Core Data
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "username == %@", self.username ?? "")
        
        do {
            let users = try context.fetch(fetchRequest)
            if let user = users.first {
                user.username = username // atualiza o username no Core Data
                try context.save()
                
                // Atualiza o estado do ViewModel para refletir a mudança
                DispatchQueue.main.async {
                    self.username = username
                }
            }
        } catch {
            print("Erro ao salvar usuário no Core Data: \(error)")
        }
    }

    
    func logout() {
        UserDefaults.standard.removeObject(forKey: "loggedInUsername")
        self.username = nil
        self.isAuthenticated = false
    }
}


