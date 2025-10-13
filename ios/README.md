# Razberry Beret iOS App

Native iOS application for Razberry Beret - The Corpus Defense System for Founders.

## Overview

Voice-first iPhone app that captures authentic founder insights through 5-question conversational sessions. Built with SwiftUI and follows MVVM architecture patterns.

## Requirements

- **iOS:** 17.0+
- **Xcode:** 15.0+
- **Swift:** 5.9+

## Architecture

### MVVM Pattern
- **Models:** Data structures and API response models
- **Views:** SwiftUI interfaces
- **ViewModels:** Observable business logic (@MainActor classes)

### Core Components

#### Views
- `ContentView` - Main app container with tab navigation
- `AuthenticationView` - Email/password login and registration
- `HomeView` - Session launcher and recent history
- `SessionView` - Voice recording and question flow
- `SessionCompletedView` - Session recap and Prince song
- `CanonView` - Brand insights viewer (placeholder)
- `SettingsView` - Account and app settings

#### ViewModels
- `AuthenticationManager` - JWT auth and session management
- `SessionManager` - Voice recording and session flow

#### Services
- `APIClient` - HTTP client for backend communication
- `KeychainManager` - Secure token storage
- `AudioRecorderManager` - AVFoundation voice recording

#### Models
- `User`, `AuthSession` - Authentication models
- `Session`, `SessionExchange` - Session flow models
- `CanonEntry`, `CanonCategory` - Brand insights models
- `PrinceSong`, `SongRecommendation` - Song recommendation models

## Project Structure

```
ios/
├── RazberryBeret.xcodeproj/
│   └── project.pbxproj
└── RazberryBeret/
    ├── RazberryBeretApp.swift      # App entry point
    ├── ContentView.swift           # Main container view
    ├── Models/
    │   └── User.swift              # Data models
    ├── ViewModels/
    │   ├── AuthenticationManager.swift
    │   └── SessionManager.swift
    ├── Views/
    │   ├── AuthenticationView.swift
    │   ├── SessionView.swift
    │   └── SessionCompletedView.swift
    ├── Services/
    │   ├── APIClient.swift
    │   ├── KeychainManager.swift
    │   └── AudioRecorderManager.swift
    ├── Assets.xcassets/
    └── Preview Content/
```

## Key Features

### Voice-First Design
- Primary interaction is voice recording
- 5-question session limit (enforced)
- Dead time optimized (quick sessions)
- AVFoundation integration

### Authentication
- Email/password registration and login
- JWT token management with refresh
- Keychain secure storage
- Biometric authentication ready

### Session Flow
1. User taps "Start Session"
2. Claude generates first question
3. User records voice response
4. Whisper transcribes audio
5. Repeat for up to 5 questions
6. Session completes with recap + Prince song

### Canon Building
- Structured insights from sessions
- 13 predefined categories
- Search and filtering (planned)
- Manual editing with audit trail

### Prince Song Canary
- Song recommendation after each session
- Mood-based selection from deep cuts
- User rating system (👍/👎)
- Drift detection mechanism

## Configuration

### Bundle Identifier
```
com.fladrycreative.razberryberet
```

### Info.plist Keys
```xml
<key>NSMicrophoneUsageDescription</key>
<string>Razberry Beret needs microphone access to record your voice sessions and capture your authentic brand insights.</string>
```

### Deployment Target
- iOS 17.0 minimum
- iPhone and iPad supported
- Portrait orientation primary

## API Integration

### Base URL
```swift
private let baseURL = URL(string: "http://localhost:3000/api/v1")!
```

### Authentication Headers
```swift
Authorization: Bearer <jwt_token>
```

### Key Endpoints
- `POST /auth/register` - Create account
- `POST /auth/login` - Sign in
- `POST /sessions` - Start new session
- `POST /anthropic/generate-question` - Get next question
- `POST /transcription/transcribe` - Voice to text
- `GET /sessions` - Recent sessions

## Data Flow

### Authentication Flow
1. User enters email/password
2. API call to `/auth/login`
3. JWT tokens stored in Keychain
4. User state updated via `@Published`
5. UI automatically updates

### Session Flow
1. `SessionManager.startNewSession()`
2. API creates session
3. Claude generates first question
4. User records voice response
5. Audio uploaded to Whisper API
6. Transcription triggers next question
7. Repeat until 5 questions complete
8. Session marked complete with recap

### Offline Support
- Authentication tokens cached
- Recent sessions cached locally
- Graceful degradation when offline
- Sync when connection restored

## Security

### Keychain Storage
- JWT tokens encrypted in iOS Keychain
- Automatic cleanup on sign out
- Device-only accessibility

### API Security
- All requests use HTTPS
- JWT token expiration handling
- Automatic token refresh
- Secure multipart file upload

## Development

### Running the App
1. Open `RazberryBeret.xcodeproj` in Xcode
2. Select iPhone simulator or device
3. Ensure backend is running on localhost:3000
4. Build and run (⌘R)

### Testing Authentication
```swift
// Test user credentials (if backend has seed data)
Email: test@example.com
Password: password123
```

### Voice Recording Testing
- Requires microphone permission
- Test on device for best results
- Simulator microphone works but limited
- Check `AVAudioSession` configuration

### Backend Connection
- Update `APIClient.baseURL` for different environments
- Development: `http://localhost:3000/api/v1`
- Production: Update to production URL

## Common Issues

### Microphone Permission
- Add usage description in Info.plist
- Request permission before recording
- Handle denial gracefully

### Audio Recording
- AVAudioSession configuration required
- File cleanup to prevent storage buildup
- Format: MPEG4AAC, 44.1kHz, stereo

### API Connectivity
- Ensure backend is running
- Check network permissions
- Handle timeout errors gracefully

## Future Enhancements

### Planned Features
- Canon full-text search
- Manual Canon editing
- Offline voice recording
- Push notifications for dead time
- Dark mode refinements
- iPad-optimized layouts

### Technical Improvements
- SwiftData for local storage
- Combine reactive patterns
- Widget extensions
- Shortcuts app integration
- CarPlay support for voice sessions

## Contributing

See main project [CONTRIBUTING.md](../CONTRIBUTING.md) for guidelines.

### iOS-Specific Guidelines
- Follow Swift API Design Guidelines
- Use SwiftUI declarative patterns
- Implement MVVM architecture
- Add proper error handling
- Include SwiftUI previews
- Test on multiple device sizes

## Build Settings

### Development Team
- Configure with your Apple Developer account
- Update bundle identifier if needed
- Set up provisioning profiles

### Release Configuration
- Enable bitcode (if supported)
- Optimize for App Store
- Include dSYM for crash reporting

## App Store Preparation

### Requirements (Planned)
- App icons (all sizes)
- Screenshots for all device types
- Privacy policy
- App Store description
- Metadata and keywords
- TestFlight beta testing

---

**Built with SwiftUI • Powered by Voice • Designed for Dead Time** 🎸
