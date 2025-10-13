import Foundation
import SwiftUI

@MainActor
class AuthenticationManager: ObservableObject {
    @Published var isAuthenticated = false
    @Published var currentUser: User?
    @Published var currentSession: AuthSession?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let apiClient = APIClient.shared
    private let keychain = KeychainManager.shared
    
    init() {
        checkAuthenticationStatus()
    }
    
    // MARK: - Authentication Status
    
    func checkAuthenticationStatus() {
        // Check for stored session
        if let storedSession = keychain.getAuthSession() {
            if !storedSession.isExpired {
                // Valid session found
                currentSession = storedSession
                isAuthenticated = true
                
                // Fetch current user info
                Task {
                    await getCurrentUser()
                }
            } else {
                // Session expired, try to refresh
                Task {
                    await refreshSession()
                }
            }
        }
    }
    
    // MARK: - Sign Up
    
    func signUp(email: String, password: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let response = try await apiClient.signUp(email: email, password: password)
            
            if let authData = response.data, 
               let user = authData.user,
               let session = authData.session {
                
                // Store session securely
                keychain.storeAuthSession(session)
                
                // Update state
                currentUser = user
                currentSession = session
                isAuthenticated = true
            } else if let error = response.error {
                errorMessage = error.message
            }
        } catch {
            errorMessage = "Registration failed: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    // MARK: - Sign In
    
    func signIn(email: String, password: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let response = try await apiClient.signIn(email: email, password: password)
            
            if let authData = response.data,
               let user = authData.user,
               let session = authData.session {
                
                // Store session securely
                keychain.storeAuthSession(session)
                
                // Update state
                currentUser = user
                currentSession = session
                isAuthenticated = true
            } else if let error = response.error {
                errorMessage = error.message
            }
        } catch {
            errorMessage = "Login failed: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    // MARK: - Sign Out
    
    func signOut() {
        Task {
            do {
                // Call backend logout endpoint
                _ = try await apiClient.signOut()
            } catch {
                print("Logout API call failed: \(error)")
                // Continue with local logout even if API call fails
            }
            
            // Clear local state
            await MainActor.run {
                currentUser = nil
                currentSession = nil
                isAuthenticated = false
                errorMessage = nil
            }
            
            // Clear stored session
            keychain.clearAuthSession()
        }
    }
    
    // MARK: - Refresh Session
    
    private func refreshSession() async {
        guard let currentSession = currentSession else {
            await signOut()
            return
        }
        
        do {
            let response = try await apiClient.refreshToken(refreshToken: currentSession.refreshToken)
            
            if let authData = response.data,
               let user = authData.user,
               let newSession = authData.session {
                
                // Store new session
                keychain.storeAuthSession(newSession)
                
                // Update state
                self.currentUser = user
                self.currentSession = newSession
                self.isAuthenticated = true
            } else {
                // Refresh failed, sign out
                await signOut()
            }
        } catch {
            // Refresh failed, sign out
            await signOut()
        }
    }
    
    // MARK: - Get Current User
    
    private func getCurrentUser() async {
        do {
            let response = try await apiClient.getCurrentUser()
            
            if let userData = response.data {
                currentUser = userData.user
            }
        } catch {
            print("Failed to get current user: \(error)")
        }
    }
    
    // MARK: - Clear Error
    
    func clearError() {
        errorMessage = nil
    }
}
