import Foundation
import SwiftUI
import AVFoundation

@MainActor
class SessionManager: ObservableObject {
    @Published var currentSession: Session?
    @Published var recentSessions: [Session] = []
    @Published var currentExchanges: [SessionExchange] = []
    @Published var isRecording = false
    @Published var isProcessing = false
    @Published var currentQuestion: String?
    @Published var questionNumber = 0
    @Published var sessionRecap: String?
    @Published var recommendedSong: PrinceSong?
    @Published var songReasoning: String?
    @Published var errorMessage: String?
    
    private let apiClient = APIClient.shared
    private let audioRecorder = AudioRecorderManager()
    private let maxQuestions = 5
    
    init() {
        Task {
            await loadRecentSessions()
        }
    }
    
    // MARK: - Session Management
    
    func startNewSession() {
        currentSession = nil
        currentExchanges = []
        currentQuestion = nil
        questionNumber = 0
        sessionRecap = nil
        recommendedSong = nil
        songReasoning = nil
        errorMessage = nil
        
        Task {
            await createSession()
            await generateFirstQuestion()
        }
    }
    
    private func createSession() async {
        do {
            // Create session on backend
            let response = try await apiClient.createSession()
            
            if let session = response.data {
                currentSession = session
            } else if let error = response.error {
                errorMessage = error.message
            }
        } catch {
            errorMessage = "Failed to create session: \(error.localizedDescription)"
        }
    }
    
    private func generateFirstQuestion() async {
        await generateQuestion(userResponse: nil, sessionContext: "Opening question for new session")
    }
    
    private func generateQuestion(userResponse: String?, sessionContext: String?) async {
        guard let session = currentSession else { return }
        
        isProcessing = true
        
        do {
            let response = try await apiClient.generateQuestion(
                userResponse: userResponse,
                sessionContext: sessionContext
            )
            
            if let questionData = response.data {
                currentQuestion = questionData.question
                questionNumber += 1
            } else if let error = response.error {
                errorMessage = error.message
            }
        } catch {
            errorMessage = "Failed to generate question: \(error.localizedDescription)"
        }
        
        isProcessing = false
    }
    
    // MARK: - Audio Recording
    
    func startRecording() async {
        guard !isRecording else { return }
        
        do {
            try await audioRecorder.startRecording()
            isRecording = true
        } catch {
            errorMessage = "Failed to start recording: \(error.localizedDescription)"
        }
    }
    
    func stopRecording() async {
        guard isRecording else { return }
        
        isRecording = false
        isProcessing = true
        
        do {
            let audioURL = try await audioRecorder.stopRecording()
            await transcribeAndProcessResponse(audioURL: audioURL)
        } catch {
            errorMessage = "Failed to stop recording: \(error.localizedDescription)"
            isProcessing = false
        }
    }
    
    private func transcribeAndProcessResponse(audioURL: URL) async {
        do {
            // Transcribe audio
            let transcriptionResponse = try await apiClient.transcribeAudio(audioURL: audioURL)
            
            guard let transcriptionData = transcriptionResponse.data else {
                if let error = transcriptionResponse.error {
                    errorMessage = error.message
                }
                isProcessing = false
                return
            }
            
            let userResponse = transcriptionData.text
            
            // Create exchange
            await createExchange(userResponse: userResponse)
            
            // Check if session is complete
            if questionNumber >= maxQuestions {
                await completeSession()
            } else {
                // Generate next question
                await generateQuestion(
                    userResponse: userResponse,
                    sessionContext: "Question \(questionNumber + 1) of \(maxQuestions)"
                )
            }
            
        } catch {
            errorMessage = "Failed to process response: \(error.localizedDescription)"
        }
        
        isProcessing = false
    }
    
    private func createExchange(userResponse: String) async {
        guard let session = currentSession,
              let question = currentQuestion else { return }
        
        do {
            let response = try await apiClient.createExchange(
                sessionId: session.id,
                questionNumber: questionNumber,
                question: question,
                userResponse: userResponse
            )
            
            if let exchange = response.data {
                currentExchanges.append(exchange)
            }
        } catch {
            errorMessage = "Failed to save response: \(error.localizedDescription)"
        }
    }
    
    private func completeSession() async {
        guard let session = currentSession else { return }
        
        do {
            // Complete session on backend
            let response = try await apiClient.completeSession(sessionId: session.id)
            
            if let completedSession = response.data {
                currentSession = completedSession
                sessionRecap = completedSession.recap
                
                // Get song recommendation
                await getSongRecommendation()
                
                // Refresh recent sessions
                await loadRecentSessions()
            }
        } catch {
            errorMessage = "Failed to complete session: \(error.localizedDescription)"
        }
    }
    
    private func getSongRecommendation() async {
        guard let session = currentSession else { return }
        
        do {
            let response = try await apiClient.getSongRecommendation(sessionId: session.id)
            
            if let recommendationData = response.data {
                recommendedSong = recommendationData.song
                songReasoning = recommendationData.reasoning
            }
        } catch {
            print("Failed to get song recommendation: \(error)")
            // Don't show error for song recommendation failure
        }
    }
    
    // MARK: - Session History
    
    private func loadRecentSessions() async {
        do {
            let response = try await apiClient.getRecentSessions()
            
            if let sessions = response.data {
                recentSessions = sessions
            }
        } catch {
            print("Failed to load recent sessions: \(error)")
        }
    }
    
    // MARK: - Song Rating
    
    func rateSong(_ rating: Int) async {
        guard let session = currentSession,
              let song = recommendedSong else { return }
        
        do {
            _ = try await apiClient.rateSong(
                sessionId: session.id,
                songId: song.id,
                rating: rating
            )
        } catch {
            print("Failed to rate song: \(error)")
        }
    }
    
    // MARK: - Error Handling
    
    func clearError() {
        errorMessage = nil
    }
}

// MARK: - Supporting Types

struct QuestionResponse: Codable {
    let question: String
}

struct SongRecommendationData: Codable {
    let song: PrinceSong
    let reasoning: String
}
