import Foundation

@MainActor
class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var isLoading = false
    @Published var error: String?
    @Published var currentUser: AuthResponse?
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    
    init() {
        // Check for existing token and fetch user data
        if UserDefaults.standard.string(forKey: "authToken") != nil {
            isAuthenticated = true
            // Fetch user profile using token
            Task {
                await fetchUserProfile()
            }
        }
    }
    
    func fetchUserProfile() async {
        // Add API call to fetch user profile if needed
        // For now, we'll just use the stored user data
        if let userData = UserDefaults.standard.data(forKey: "userData"),
           let user = try? JSONDecoder().decode(AuthResponse.self, from: userData) {
            await MainActor.run {
                self.currentUser = user
            }
        }
    }
    
    func login(email: String, password: String) {
        guard !email.isEmpty && !password.isEmpty else {
            self.error = "Please fill in all fields"
            return
        }
        
        isLoading = true
        error = nil
        
        Task {
            do {
                let response = try await APIClient.shared.login(email: email, password: password)
                await MainActor.run {
                    self.currentUser = response
                    self.isAuthenticated = true
                    self.saveUserData(response)
                    self.saveToken(response.token)
                }
            } catch let apiError as APIError {
                await MainActor.run {
                    switch apiError {
                    case .serverError(let message):
                        self.error = message
                    case .networkError:
                        self.error = "Network error. Please check your connection."
                    case .invalidURL:
                        self.error = "Invalid URL"
                    case .decodingError:
                        self.error = "Error processing response"
                    case .unknownError:
                        self.error = "An unexpected error occurred"
                    }
                }
            } catch {
                await MainActor.run {
                    self.error = "An unexpected error occurred"
                }
            }
            
            await MainActor.run {
                self.isLoading = false
            }
        }
    }
    
    func logout() {
        print("Logging out...")
        UserDefaults.standard.removeObject(forKey: "authToken")
        UserDefaults.standard.removeObject(forKey: "userData")
        isAuthenticated = false
        currentUser = nil
        print("User logged out. Current user: \(String(describing: currentUser))")
    }
    
    private func saveToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: "authToken")
    }
    
    private func saveUserData(_ user: AuthResponse) {
        if let encoded = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(encoded, forKey: "userData")
        }
    }
    
    func register(name: String, email: String, password: String) {
        print("Attempting registration with email: \(email)")
        isLoading = true
        error = nil
        
        Task {
            do {
                let response = try await APIClient.shared.register(name: name, email: email, password: password)
                print("Registration successful: \(response)")
                await MainActor.run {
                    self.currentUser = response
                    self.isAuthenticated = true
                    self.saveUserData(response)
                    self.saveToken(response.token)
                }
            } catch let apiError as APIError {
                print("Registration failed with APIError: \(apiError)")
                await MainActor.run {
                    switch apiError {
                    case .serverError(let message):
                        self.error = message
                    default:
                        self.error = "An error occurred. Please try again."
                    }
                }
            } catch {
                print("Registration failed with error: \(error)")
                await MainActor.run {
                    self.error = "An unexpected error occurred"
                }
            }
            await MainActor.run {
                self.isLoading = false
            }
        }
    }
}

extension UserDefaults {
    var authToken: String? {
        string(forKey: "authToken")
    }
} 
