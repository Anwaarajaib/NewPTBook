import SwiftUI

struct SplashScreenView: View {
    @StateObject private var authViewModel = AuthViewModel()
    @State private var showLogin = false
    @State private var showRegister = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                // Logo and Title
                VStack(spacing: 20) {
                    Image("app-logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                    
                    Text("PT Book")
                        .font(.system(size: 40, weight: .bold))
                }
                
                // Buttons
                VStack(spacing: 16) {
                    Button {
                        showLogin = true
                    } label: {
                        Text("Login")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                    Button {
                        showRegister = true
                    } label: {
                        Text("Register")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .foregroundColor(.blue)
                            .cornerRadius(10)
                    }
                }
                .padding(.horizontal, 40)
            }
            .navigationDestination(isPresented: $showLogin) {
                LoginView()
                    .environmentObject(authViewModel)
            }
            .navigationDestination(isPresented: $showRegister) {
                RegisterView()
                    .environmentObject(authViewModel)
            }
        }
    }
}

#Preview {
    SplashScreenView()
} 