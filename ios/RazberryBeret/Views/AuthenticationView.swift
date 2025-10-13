import SwiftUI

struct AuthenticationView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    @State private var isSignUp = false
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                // Header
                VStack(spacing: 16) {
                    Text("🎸")
                        .font(.system(size: 80))
                    
                    Text("Razberry Beret")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.purple)
                    
                    Text("Don't let AI turn you into a statistically average founder.")
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                }
                .padding(.top, 40)
                
                Spacer()
                
                // Form
                VStack(spacing: 20) {
                    VStack(spacing: 12) {
                        TextField("Email", text: $email)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .textContentType(.emailAddress)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                        
                        SecureField("Password", text: $password)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .textContentType(isSignUp ? .newPassword : .password)
                        
                        if isSignUp {
                            SecureField("Confirm Password", text: $confirmPassword)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .textContentType(.newPassword)
                        }
                    }
                    .padding(.horizontal, 40)
                    
                    // Error Message
                    if let errorMessage = authManager.errorMessage {
                        Text(errorMessage)
                            .font(.caption)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                    }
                    
                    // Action Button
                    Button(action: {
                        Task {
                            await handleAuthentication()
                        }
                    }) {
                        HStack {
                            if authManager.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .scaleEffect(0.8)
                            }
                            
                            Text(isSignUp ? "Create Account" : "Sign In")
                                .font(.headline)
                                .fontWeight(.semibold)
                        }
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(
                            LinearGradient(
                                colors: [.purple, .pink],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(16)
                    }
                    .disabled(authManager.isLoading || !isFormValid)
                    .opacity(authManager.isLoading || !isFormValid ? 0.6 : 1.0)
                    .padding(.horizontal, 40)
                    
                    // Toggle Mode
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            isSignUp.toggle()
                            clearForm()
                        }
                    }) {
                        HStack(spacing: 4) {
                            Text(isSignUp ? "Already have an account?" : "Don't have an account?")
                                .foregroundColor(.secondary)
                            
                            Text(isSignUp ? "Sign In" : "Sign Up")
                                .foregroundColor(.purple)
                                .fontWeight(.semibold)
                        }
                        .font(.subheadline)
                    }
                }
                
                Spacer()
                
                // Footer
                VStack(spacing: 8) {
                    Text("By continuing, you agree to our Terms of Service")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    
                    Text("Voice-first • Privacy-focused • Founder-built")
                        .font(.caption2)
                        .foregroundColor(.secondary.opacity(0.7))
                }
                .multilineTextAlignment(.center)
                .padding(.bottom, 20)
            }
            .navigationBarHidden(true)
        }
        .onTapGesture {
            hideKeyboard()
        }
        .onChange(of: authManager.errorMessage) { _ in
            // Clear error when user starts typing
            if authManager.errorMessage != nil {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    authManager.clearError()
                }
            }
        }
    }
    
    private var isFormValid: Bool {
        if isSignUp {
            return !email.isEmpty &&
                   !password.isEmpty &&
                   !confirmPassword.isEmpty &&
                   password == confirmPassword &&
                   password.count >= 8 &&
                   isValidEmail(email)
        } else {
            return !email.isEmpty && !password.isEmpty && isValidEmail(email)
        }
    }
    
    private func handleAuthentication() async {
        hideKeyboard()
        
        if isSignUp {
            await authManager.signUp(email: email, password: password)
        } else {
            await authManager.signIn(email: email, password: password)
        }
    }
    
    private func clearForm() {
        email = ""
        password = ""
        confirmPassword = ""
        authManager.clearError()
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = #"^[^\s@]+@[^\s@]+\.[^\s@]+$"#
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    AuthenticationView()
        .environmentObject(AuthenticationManager())
}
