import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var email = ""
    @State private var password = ""
    @State private var showPassword = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Welcome Back")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            VStack(spacing: 15) {
                TextField("Email", text: $email)
                    .textFieldStyle(CustomTextFieldStyle())
                    .textContentType(.emailAddress)
                    .autocapitalization(.none)
                
                ZStack(alignment: .trailing) {
                    if showPassword {
                        TextField("Password", text: $password)
                            .textFieldStyle(CustomTextFieldStyle())
                    } else {
                        SecureField("Password", text: $password)
                            .textFieldStyle(CustomTextFieldStyle())
                    }
                    
                    Button(action: { showPassword.toggle() }) {
                        Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                            .foregroundColor(.gray)
                    }
                    .padding(.trailing, 8)
                }
            }
            .padding(.horizontal, 32)
            
            if let error = authViewModel.error {
                Text(error)
                    .foregroundColor(.red)
                    .font(.caption)
                    .padding(.horizontal)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: { authViewModel.login(email: email, password: password) }) {
                if authViewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Text("Login")
                        .fontWeight(.semibold)
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.horizontal, 32)
            .disabled(authViewModel.isLoading)
            
            Spacer()
            
            Button("Don't have an account? Register") {
                dismiss()
            }
            .foregroundColor(.blue)
        }
        .padding(.top, 50)
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthViewModel())
} 