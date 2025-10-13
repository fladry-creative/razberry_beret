import Foundation

// MARK: - User Models

struct User: Codable, Identifiable {
    let id: String
    let email: String
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case email
        case createdAt = "created_at"
    }
}

struct AuthSession: Codable {
    let accessToken: String
    let refreshToken: String
    let expiresAt: TimeInterval
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case expiresAt = "expires_at"
    }
    
    var isExpired: Bool {
        Date().timeIntervalSince1970 >= expiresAt
    }
}

struct AuthResponse: Codable {
    let success: Bool
    let data: AuthData?
    let error: APIError?
    
    struct AuthData: Codable {
        let user: User?
        let session: AuthSession?
        let message: String?
    }
}

// MARK: - Session Models

struct Session: Codable, Identifiable {
    let id: String
    let userId: String
    let createdAt: String
    let completedAt: String?
    let status: SessionStatus
    let questionCount: Int
    let princeSongId: String?
    let recap: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case createdAt = "created_at"
        case completedAt = "completed_at"
        case status
        case questionCount = "question_count"
        case princeSongId = "prince_song_id"
        case recap
    }
}

enum SessionStatus: String, Codable, CaseIterable {
    case inProgress = "in_progress"
    case completed = "completed"
    case abandoned = "abandoned"
    
    var displayName: String {
        switch self {
        case .inProgress:
            return "In Progress"
        case .completed:
            return "Completed"
        case .abandoned:
            return "Abandoned"
        }
    }
}

struct SessionExchange: Codable, Identifiable {
    let id: String
    let sessionId: String
    let questionNumber: Int
    let question: String
    let userResponse: String
    let transcriptionConfidence: Double?
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case sessionId = "session_id"
        case questionNumber = "question_number"
        case question
        case userResponse = "user_response"
        case transcriptionConfidence = "transcription_confidence"
        case createdAt = "created_at"
    }
}

// MARK: - Canon Models

struct CanonEntry: Codable, Identifiable {
    let id: String
    let userId: String
    let category: CanonCategory
    let content: String
    let sourceSessionId: String?
    let createdAt: String
    let updatedAt: String
    let manuallyEdited: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case category
        case content
        case sourceSessionId = "source_session_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case manuallyEdited = "manually_edited"
    }
}

enum CanonCategory: String, Codable, CaseIterable {
    case mission
    case vision
    case voice
    case principles
    case values
    case positioning
    case customerPhilosophy = "customer_philosophy"
    case productPrinciples = "product_principles"
    case foundingStory = "founding_story"
    case nonNegotiables = "non_negotiables"
    case aesthetic
    case competitiveStance = "competitive_stance"
    case other
    
    var displayName: String {
        switch self {
        case .mission:
            return "Mission"
        case .vision:
            return "Vision"
        case .voice:
            return "Brand Voice"
        case .principles:
            return "Principles"
        case .values:
            return "Values"
        case .positioning:
            return "Positioning"
        case .customerPhilosophy:
            return "Customer Philosophy"
        case .productPrinciples:
            return "Product Principles"
        case .foundingStory:
            return "Founding Story"
        case .nonNegotiables:
            return "Non-Negotiables"
        case .aesthetic:
            return "Aesthetic"
        case .competitiveStance:
            return "Competitive Stance"
        case .other:
            return "Other"
        }
    }
    
    var icon: String {
        switch self {
        case .mission:
            return "target"
        case .vision:
            return "eye"
        case .voice:
            return "speaker.wave.3"
        case .principles:
            return "list.bullet.rectangle"
        case .values:
            return "heart"
        case .positioning:
            return "location"
        case .customerPhilosophy:
            return "person.2"
        case .productPrinciples:
            return "cube.box"
        case .foundingStory:
            return "book"
        case .nonNegotiables:
            return "exclamationmark.shield"
        case .aesthetic:
            return "paintbrush"
        case .competitiveStance:
            return "flag"
        case .other:
            return "ellipsis.circle"
        }
    }
}

// MARK: - Prince Song Models

struct PrinceSong: Codable, Identifiable {
    let id: String
    let title: String
    let album: String?
    let year: Int?
    let isDeepCut: Bool
    let spotifyUrl: String?
    let appleMusicUrl: String?
    let moodTags: [String]
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case album
        case year
        case isDeepCut = "is_deep_cut"
        case spotifyUrl = "spotify_url"
        case appleMusicUrl = "apple_music_url"
        case moodTags = "mood_tags"
    }
}

struct SongRecommendation: Codable, Identifiable {
    let id: String
    let sessionId: String
    let songId: String
    let reasoning: String
    let userRating: Int?
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case sessionId = "session_id"
        case songId = "song_id"
        case reasoning
        case userRating = "user_rating"
        case createdAt = "created_at"
    }
}

// MARK: - API Response Models

struct APIError: Codable, Error {
    let message: String
    let code: String?
}

struct APIResponse<T: Codable>: Codable {
    let success: Bool
    let data: T?
    let error: APIError?
}

// MARK: - Transcription Models

struct TranscriptionResult: Codable {
    let text: String
    let duration: Double?
    let language: String?
}

struct TranscriptionResponse: Codable {
    let success: Bool
    let data: TranscriptionResult?
    let error: APIError?
}
