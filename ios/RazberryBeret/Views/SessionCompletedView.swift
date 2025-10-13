import SwiftUI

struct SessionCompletedView: View {
    @EnvironmentObject var sessionManager: SessionManager
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                // Header
                VStack(spacing: 16) {
                    Text("🎉")
                        .font(.system(size: 60))
                    
                    Text("Session Complete!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("You've successfully captured 5 authentic insights")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 40)
                
                // Session Summary
                if let recap = sessionManager.sessionRecap {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Session Recap")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        Text(recap)
                            .font(.body)
                            .padding()
                            .background(Color(UIColor.secondarySystemGroupedBackground))
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                }
                
                // Prince Song Recommendation
                if let song = sessionManager.recommendedSong,
                   let reasoning = sessionManager.songReasoning {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Your Prince Song")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(song.title)
                                        .font(.title3)
                                        .fontWeight(.semibold)
                                    
                                    if let album = song.album, let year = song.year {
                                        Text("\(album) (\(year))")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
                                }
                                
                                Spacer()
                                
                                Text("🎵")
                                    .font(.system(size: 30))
                            }
                            
                            Text(reasoning)
                                .font(.body)
                                .foregroundColor(.secondary)
                            
                            // Rating buttons
                            HStack(spacing: 16) {
                                Text("Rate this recommendation:")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                
                                Spacer()
                                
                                Button(action: {
                                    Task {
                                        await sessionManager.rateSong(1)
                                    }
                                }) {
                                    Image(systemName: "hand.thumbsdown")
                                        .foregroundColor(.red)
                                }
                                
                                Button(action: {
                                    Task {
                                        await sessionManager.rateSong(2)
                                    }
                                }) {
                                    Image(systemName: "hand.thumbsup")
                                        .foregroundColor(.green)
                                }
                            }
                            .padding(.top, 8)
                        }
                        .padding()
                        .background(Color.purple.opacity(0.1))
                        .cornerRadius(12)
                    }
                    .padding(.horizontal)
                }
                
                Spacer()
                
                // Actions
                VStack(spacing: 16) {
                    Button("View Your Canon") {
                        dismiss()
                        // Navigate to Canon tab (this would be handled by the parent)
                    }
                    .font(.headline)
                    .fontWeight(.semibold)
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
                    .padding(.horizontal)
                    
                    Button("Start Another Session") {
                        dismiss()
                        // Start a new session
                        sessionManager.startNewSession()
                    }
                    .font(.subheadline)
                    .foregroundColor(.purple)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.purple.opacity(0.1))
                    .cornerRadius(16)
                    .padding(.horizontal)
                }
                .padding(.bottom, 40)
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    SessionCompletedView()
        .environmentObject(SessionManager())
}
