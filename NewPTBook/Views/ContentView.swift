import SwiftUI

struct ContentView: View {
    @StateObject private var authViewModel = AuthViewModel()
    @State private var isRegistering: Bool = false
    @State private var message: String = ""

    var body: some View {
        VStack {
            if authViewModel.isAuthenticated {
                HomeView()
            } else {
                if isRegistering {
                    TextField("Name", text: $authViewModel.name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    // ... other registration fields ...
                }
                TextField("Email", text: $authViewModel.email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                SecureField("Password", text: $authViewModel.password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button(action: {
                    if isRegistering {
                        authViewModel.register(name: authViewModel.name, email: authViewModel.email, password: authViewModel.password)
                    } else {
                        authViewModel.login(email: authViewModel.email, password: authViewModel.password)
                    }
                }) {
                    Text(isRegistering ? "Register" : "Login")
                }
                if let error = authViewModel.error {
                    Text(error)
                        .foregroundColor(.red)
                }
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
} 
