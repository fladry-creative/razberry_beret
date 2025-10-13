import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    @State private var selectedTab = 0
    
    var body: some View {
        Group {
            if authManager.isAuthenticated {
                // Main app interface
                TabView(selection: $selectedTab) {
                    HomeView()
                        .tabItem {
                            Image(systemName: "house.fill")
                            Text("Home")
                        }
                        .tag(0)
                    
                    CanonView()
                        .tabItem {
                            Image(systemName: "book.fill")
                            Text("Canon")
                        }
                        .tag(1)
                    
                    SettingsView()
                        .tabItem {
                            Image(systemName: "gear")
                            Text("Settings")
                        }
                        .tag(2)
                }
                .accentColor(.purple)
            } else {
                // Authentication flow
                AuthenticationView()
            }
        }
        .onAppear {
            // Check for existing session on app launch
            authManager.checkAuthenticationStatus()
        }
    }
}

// MARK: - Home View
struct HomeView: View {
    @EnvironmentObject var sessionManager: SessionManager
    @State private var showingSessionView = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                // Header
                VStack(spacing: 10) {
                    Text("🎸")
                        .font(.system(size: 60))
                    
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
                
                // Main Action Button
                VStack(spacing: 20) {
                    Button(action: {
                        startNewSession()
                    }) {
                        HStack {
                            Image(systemName: "mic.fill")
                                .font(.title2)
                            Text("Start Session")
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
                    .padding(.horizontal, 40)
                    
                    Text("5 questions max • Voice only • Dead time friendly")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                // Recent Sessions
                if !sessionManager.recentSessions.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Recent Sessions")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        LazyVStack(spacing: 8) {
                            ForEach(sessionManager.recentSessions.prefix(3)) { session in
                                SessionRowView(session: session)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                
                Spacer()
            }
            .navigationTitle("")
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showingSessionView) {
            SessionView()
        }
    }
    
    private func startNewSession() {
        sessionManager.startNewSession()
        showingSessionView = true
    }
}

// MARK: - Canon View
struct CanonView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 16) {
                    Text("Your Canon")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top)
                    
                    Text("Your brand's source code, captured through authentic conversations.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    // Canon content will be populated here
                    VStack {
                        Image(systemName: "book.closed")
                            .font(.system(size: 60))
                            .foregroundColor(.purple.opacity(0.5))
                        
                        Text("Canon Coming Soon")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        Text("Complete a few sessions to start building your brand canon.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 60)
                }
            }
            .navigationBarHidden(true)
        }
    }
}

// MARK: - Settings View
struct SettingsView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    HStack {
                        Text("🎸")
                        VStack(alignment: .leading) {
                            Text("Razberry Beret")
                                .font(.headline)
                            Text("v1.0.0")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                Section("Account") {
                    if let user = authManager.currentUser {
                        HStack {
                            Text("Email")
                            Spacer()
                            Text(user.email)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Button("Sign Out") {
                        authManager.signOut()
                    }
                    .foregroundColor(.red)
                }
                
                Section("About") {
                    Link(destination: URL(string: "https://github.com/fladry-creative/razberry_beret")!) {
                        HStack {
                            Text("GitHub Repository")
                            Spacer()
                            Image(systemName: "arrow.up.right.square")
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}

// MARK: - Preview
#Preview {
    ContentView()
        .environmentObject(AuthenticationManager())
        .environmentObject(SessionManager())
}
