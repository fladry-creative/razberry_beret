import SwiftUI

@main
struct RazberryBeretApp: App {
    @StateObject private var authManager = AuthenticationManager()
    @StateObject private var sessionManager = SessionManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authManager)
                .environmentObject(sessionManager)
                .preferredColorScheme(.dark) // Default to dark theme
        }
    }
}
