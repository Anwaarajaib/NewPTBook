import Foundation

enum APIError: Error {
    case invalidURL
    case networkError
    case decodingError
    case serverError(String)
    case unknownError
} 