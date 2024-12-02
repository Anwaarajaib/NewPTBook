import Foundation

class APIClient {
    static let shared = APIClient()
    private let baseURL = "http://localhost:5001/api"
    
    private init() {}
    
    func login(email: String, password: String) async throws -> AuthResponse {
        guard let url = URL(string: "\(baseURL)/auth/login") else {
            throw APIError.invalidURL
        }
        
        let body = ["email": email, "password": password]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.networkError
        }
        
        if httpResponse.statusCode == 200 {
            return try JSONDecoder().decode(AuthResponse.self, from: data)
        } else {
            if let errorResponse = try? JSONDecoder().decode([String: String].self, from: data),
               let message = errorResponse["message"] {
                throw APIError.serverError(message)
            }
            throw APIError.serverError("Login failed")
        }
    }
    
    func register(name: String, email: String, password: String) async throws -> AuthResponse {
        guard let url = URL(string: "\(baseURL)/auth/register") else {
            throw APIError.invalidURL
        }
        
        let body = [
            "name": name,
            "email": email,
            "password": password
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.networkError
        }
        
        if httpResponse.statusCode == 200 {
            return try JSONDecoder().decode(AuthResponse.self, from: data)
        } else {
            if let errorResponse = try? JSONDecoder().decode([String: String].self, from: data),
               let message = errorResponse["message"] {
                throw APIError.serverError(message)
            }
            throw APIError.serverError("Registration failed")
        }
    }
    
    func getClients() async throws -> [Client] {
        guard let url = URL(string: "\(baseURL)/clients") else {
            throw APIError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw APIError.networkError
        }
        
        let clients = try JSONDecoder().decode([Client].self, from: data)
        return clients
    }
    
    func createClient(client: Client) async throws -> Client {
        guard let url = URL(string: "\(baseURL)/clients") else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(client)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 else {
            throw APIError.networkError
        }
        
        let createdClient = try JSONDecoder().decode(Client.self, from: data)
        return createdClient
    }
    
    func updateClient(client: Client) async throws -> Client {
        guard let url = URL(string: "\(baseURL)/clients/\(client.id)") else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(client)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw APIError.networkError
        }
        
        let updatedClient = try JSONDecoder().decode(Client.self, from: data)
        return updatedClient
    }
    
    func deleteClient(clientId: String) async throws {
        guard let url = URL(string: "\(baseURL)/clients/\(clientId)") else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 204 else {
            throw APIError.networkError
        }
    }
} 
