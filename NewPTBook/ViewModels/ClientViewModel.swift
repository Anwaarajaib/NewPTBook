import Foundation

@MainActor
class ClientViewModel: ObservableObject {
    @Published var clients: [Client] = []
    
    func fetchClients() async {
        do {
            clients = try await APIClient.shared.getClients()
        } catch {
            print("Error fetching clients: \(error)")
        }
    }
    
    func addClient(client: Client) async {
        do {
            let newClient = try await APIClient.shared.createClient(client: client)
            clients.append(newClient)
        } catch {
            print("Error creating client: \(error)")
        }
    }
    
    func updateClient(client: Client) async {
        do {
            let updatedClient = try await APIClient.shared.updateClient(client: client)
            if let index = clients.firstIndex(where: { $0.id == updatedClient.id }) {
                clients[index] = updatedClient
            }
        } catch {
            print("Error updating client: \(error)")
        }
    }
    
    func removeClient(clientId: String) async {
        do {
            try await APIClient.shared.deleteClient(clientId: clientId)
            clients.removeAll { $0.id == clientId }
        } catch {
            print("Error deleting client: \(error)")
        }
    }
} 