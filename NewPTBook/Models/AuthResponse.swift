import Foundation

struct AuthResponse: Codable {
    let id: String
    let name: String
    let email: String
    let token: String
} 