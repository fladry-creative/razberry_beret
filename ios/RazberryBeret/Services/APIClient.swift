import Foundation

class APIClient {
    static let shared = APIClient()
    
    private let baseURL = URL(string: "http://localhost:3000/api/v1")!
    private let session = URLSession.shared
    private let keychain = KeychainManager.shared
    
    private init() {}
    
    // MARK: - Authentication
    
    func signUp(email: String, password: String) async throws -> AuthResponse {
        let endpoint = baseURL.appendingPathComponent("auth/register")
        
        let body = [
            "email": email,
            "password": password
        ]
        
        return try await performRequest(endpoint: endpoint, method: "POST", body: body)
    }
    
    func signIn(email: String, password: String) async throws -> AuthResponse {
        let endpoint = baseURL.appendingPathComponent("auth/login")
        
        let body = [
            "email": email,
            "password": password
        ]
        
        return try await performRequest(endpoint: endpoint, method: "POST", body: body)
    }
    
    func signOut() async throws -> APIResponse<EmptyResponse> {
        let endpoint = baseURL.appendingPathComponent("auth/logout")
        return try await performAuthenticatedRequest(endpoint: endpoint, method: "POST")
    }
    
    func refreshToken(refreshToken: String) async throws -> AuthResponse {
        let endpoint = baseURL.appendingPathComponent("auth/refresh")
        
        let body = [
            "refresh_token": refreshToken
        ]
        
        return try await performRequest(endpoint: endpoint, method: "POST", body: body)
    }
    
    func getCurrentUser() async throws -> APIResponse<AuthResponse.AuthData> {
        let endpoint = baseURL.appendingPathComponent("auth/me")
        return try await performAuthenticatedRequest(endpoint: endpoint, method: "GET")
    }
    
    // MARK: - Sessions
    
    func createSession() async throws -> APIResponse<Session> {
        let endpoint = baseURL.appendingPathComponent("sessions")
        return try await performAuthenticatedRequest(endpoint: endpoint, method: "POST")
    }
    
    func completeSession(sessionId: String) async throws -> APIResponse<Session> {
        let endpoint = baseURL.appendingPathComponent("sessions/\(sessionId)")
        let body = ["status": "completed"]
        return try await performAuthenticatedRequest(endpoint: endpoint, method: "PATCH", body: body)
    }
    
    func getRecentSessions() async throws -> APIResponse<[Session]> {
        let endpoint = baseURL.appendingPathComponent("sessions")
        return try await performAuthenticatedRequest(endpoint: endpoint, method: "GET")
    }
    
    func createExchange(sessionId: String, questionNumber: Int, question: String, userResponse: String) async throws -> APIResponse<SessionExchange> {
        let endpoint = baseURL.appendingPathComponent("sessions/\(sessionId)/exchanges")
        
        let body = [
            "question_number": questionNumber,
            "question": question,
            "user_response": userResponse
        ] as [String: Any]
        
        return try await performAuthenticatedRequest(endpoint: endpoint, method: "POST", body: body)
    }
    
    // MARK: - AI Services
    
    func generateQuestion(userResponse: String?, sessionContext: String?) async throws -> APIResponse<QuestionResponse> {
        let endpoint = baseURL.appendingPathComponent("anthropic/generate-question")
        
        var body: [String: Any] = [:]
        if let userResponse = userResponse {
            body["userResponse"] = userResponse
        }
        if let sessionContext = sessionContext {
            body["sessionContext"] = sessionContext
        }
        
        return try await performAuthenticatedRequest(endpoint: endpoint, method: "POST", body: body)
    }
    
    func transcribeAudio(audioURL: URL) async throws -> TranscriptionResponse {
        let endpoint = baseURL.appendingPathComponent("transcription/transcribe")
        return try await performAudioUpload(endpoint: endpoint, audioURL: audioURL)
    }
    
    // MARK: - Songs
    
    func getSongRecommendation(sessionId: String) async throws -> APIResponse<SongRecommendationData> {
        let endpoint = baseURL.appendingPathComponent("songs/recommendation/\(sessionId)")
        return try await performAuthenticatedRequest(endpoint: endpoint, method: "GET")
    }
    
    func rateSong(sessionId: String, songId: String, rating: Int) async throws -> APIResponse<EmptyResponse> {
        let endpoint = baseURL.appendingPathComponent("songs/recommendation/\(sessionId)/rate")
        let body = ["rating": rating]
        return try await performAuthenticatedRequest(endpoint: endpoint, method: "POST", body: body)
    }
    
    // MARK: - Private Helper Methods
    
    private func performRequest<T: Codable>(
        endpoint: URL,
        method: String,
        body: [String: Any]? = nil,
        headers: [String: String]? = nil
    ) async throws -> T {
        var request = URLRequest(url: endpoint)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Add custom headers
        headers?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        // Add body if provided
        if let body = body {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        }
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError(message: "Invalid response", code: "INVALID_RESPONSE")
        }
        
        guard 200...299 ~= httpResponse.statusCode else {
            // Try to decode error response
            if let errorResponse = try? JSONDecoder().decode(APIResponse<EmptyResponse>.self, from: data),
               let error = errorResponse.error {
                throw error
            } else {
                throw APIError(message: "HTTP \(httpResponse.statusCode)", code: "HTTP_ERROR")
            }
        }
        
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    private func performAuthenticatedRequest<T: Codable>(
        endpoint: URL,
        method: String,
        body: [String: Any]? = nil
    ) async throws -> T {
        guard let session = keychain.getAuthSession() else {
            throw APIError(message: "No authentication token", code: "UNAUTHENTICATED")
        }
        
        let headers = [
            "Authorization": "Bearer \(session.accessToken)"
        ]
        
        return try await performRequest(
            endpoint: endpoint,
            method: method,
            body: body,
            headers: headers
        )
    }
    
    private func performAudioUpload(endpoint: URL, audioURL: URL) async throws -> TranscriptionResponse {
        guard let session = keychain.getAuthSession() else {
            throw APIError(message: "No authentication token", code: "UNAUTHENTICATED")
        }
        
        var request = URLRequest(url: endpoint)
        request.httpMethod = "POST"
        request.setValue("Bearer \(session.accessToken)", forHTTPHeaderField: "Authorization")
        
        // Create multipart form data
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let audioData = try Data(contentsOf: audioURL)
        let httpBody = createMultipartBody(boundary: boundary, audioData: audioData, filename: "audio.m4a")
        request.httpBody = httpBody
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError(message: "Invalid response", code: "INVALID_RESPONSE")
        }
        
        guard 200...299 ~= httpResponse.statusCode else {
            throw APIError(message: "HTTP \(httpResponse.statusCode)", code: "HTTP_ERROR")
        }
        
        return try JSONDecoder().decode(TranscriptionResponse.self, from: data)
    }
    
    private func createMultipartBody(boundary: String, audioData: Data, filename: String) -> Data {
        var body = Data()
        
        // Add audio file
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"audio\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: audio/mp4\r\n\r\n".data(using: .utf8)!)
        body.append(audioData)
        body.append("\r\n".data(using: .utf8)!)
        
        // End boundary
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        return body
    }
}

// MARK: - Empty Response Type

struct EmptyResponse: Codable {}
