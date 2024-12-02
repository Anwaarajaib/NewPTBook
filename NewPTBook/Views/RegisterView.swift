import SwiftUI

struct RegisterView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var showPassword = false
    @State private var showConfirmPassword = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Create Account")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            VStack(spacing: 15) {
                TextField("Name", text: $name)
                    .textFieldStyle(CustomTextFieldStyle())
                    .textContentType(.name)
                    .autocapitalization(.words)
                
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
                
                ZStack(alignment: .trailing) {
                    if showConfirmPassword {
                        TextField("Confirm Password", text: $confirmPassword)
                            .textFieldStyle(CustomTextFieldStyle())
                    } else {
                        SecureField("Confirm Password", text: $confirmPassword)
                            .textFieldStyle(CustomTextFieldStyle())
                    }
                    
                    Button(action: { showConfirmPassword.toggle() }) {
                        Image(systemName: showConfirmPassword ? "eye.slash.fill" : "eye.fill")
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
            }
            
            Button(action: handleRegister) {
                if authViewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Text("Register")
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
            
            Button("Already have an account? Login") {
                dismiss()
            }
            .foregroundColor(.blue)
        }
        .padding(.top, 50)
    }
    
    private func handleRegister() {
        guard password == confirmPassword else {
            authViewModel.error = "Passwords do not match"
            return
        }
        
        authViewModel.register(name: name, email: email, password: password)
    }
}

#Preview {
    RegisterView()
        .environmentObject(AuthViewModel())
} 