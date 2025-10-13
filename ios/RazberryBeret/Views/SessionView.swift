import SwiftUI

struct SessionView: View {
    @EnvironmentObject var sessionManager: SessionManager
    @Environment(\.dismiss) var dismiss
    @State private var showingCompletedSession = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                // Header
                VStack(spacing: 8) {
                    HStack {
                        Button("Cancel") {
                            dismiss()
                        }
                        .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        Text("Session")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        Spacer()
                        
                        Text("\(sessionManager.questionNumber)/5")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal)
                    
                    // Progress Bar
                    ProgressView(value: Double(sessionManager.questionNumber), total: 5.0)
                        .progressViewStyle(LinearProgressViewStyle(tint: .purple))
                        .padding(.horizontal)
                }
                .padding(.top)
                
                if sessionManager.isProcessing {
                    ProcessingView()
                } else if let question = sessionManager.currentQuestion {
                    ActiveQuestionView(question: question)
                } else {
                    LoadingView()
                }
                
                Spacer()
            }
        }
        .sheet(isPresented: $showingCompletedSession) {
            SessionCompletedView()
        }
        .onChange(of: sessionManager.sessionRecap) { recap in
            if recap != nil {
                showingCompletedSession = true
            }
        }
    }
}

// MARK: - Processing View
struct ProcessingView: View {
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            // Animated microphone
            VStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(Color.purple.opacity(0.1))
                        .frame(width: 120, height: 120)
                    
                    Circle()
                        .fill(Color.purple.opacity(0.2))
                        .frame(width: 90, height: 90)
                        .scaleEffect(1.0)
                        .animation(.easeInOut(duration: 1.5).repeatForever(), value: UUID())
                    
                    Image(systemName: "brain")
                        .font(.system(size: 40))
                        .foregroundColor(.purple)
                }
                
                Text("Processing your response...")
                    .font(.headline)
                    .fontWeight(.medium)
                
                Text("Generating your next question")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
    }
}

// MARK: - Active Question View
struct ActiveQuestionView: View {
    @EnvironmentObject var sessionManager: SessionManager
    let question: String
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            // Question
            VStack(spacing: 16) {
                Text("Question \(sessionManager.questionNumber)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .textCase(.uppercase)
                    .tracking(1)
                
                Text(question)
                    .font(.title2)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
            }
            
            Spacer()
            
            // Recording Controls
            VStack(spacing: 20) {
                // Record Button
                Button(action: {
                    Task {
                        if sessionManager.isRecording {
                            await sessionManager.stopRecording()
                        } else {
                            await sessionManager.startRecording()
                        }
                    }
                }) {
                    ZStack {
                        Circle()
                            .fill(sessionManager.isRecording ? Color.red : Color.purple)
                            .frame(width: 80, height: 80)
                            .scaleEffect(sessionManager.isRecording ? 1.1 : 1.0)
                            .animation(.easeInOut(duration: 0.15), value: sessionManager.isRecording)
                        
                        if sessionManager.isRecording {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.white)
                                .frame(width: 24, height: 24)
                        } else {
                            Image(systemName: "mic.fill")
                                .font(.system(size: 24))
                                .foregroundColor(.white)
                        }
                    }
                }
                
                Text(sessionManager.isRecording ? "Tap to stop recording" : "Tap to record your answer")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                
                if sessionManager.isRecording {
                    // Recording indicator
                    HStack(spacing: 8) {
                        Circle()
                            .fill(Color.red)
                            .frame(width: 8, height: 8)
                            .opacity(0.8)
                            .animation(.easeInOut(duration: 1).repeatForever(), value: UUID())
                        
                        Text("Recording...")
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                }
            }
            .padding(.bottom, 40)
        }
    }
}

// MARK: - Loading View
struct LoadingView: View {
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .purple))
                .scaleEffect(1.2)
            
            Text("Preparing your session...")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Spacer()
        }
    }
}

// MARK: - Session Row View
struct SessionRowView: View {
    let session: Session
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(formattedDate(session.createdAt))
                    .font(.headline)
                    .fontWeight(.medium)
                
                Text("\(session.questionCount) questions • \(session.status.displayName)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .cornerRadius(12)
    }
    
    private func formattedDate(_ dateString: String) -> String {
        let formatter = ISO8601DateFormatter()
        if let date = formatter.date(from: dateString) {
            let displayFormatter = DateFormatter()
            displayFormatter.dateStyle = .medium
            displayFormatter.timeStyle = .short
            return displayFormatter.string(from: date)
        }
        return dateString
    }
}

#Preview {
    SessionView()
        .environmentObject(SessionManager())
}
