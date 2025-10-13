# Contributing to Razberry Beret

Thank you for considering contributing to Razberry Beret! This document provides guidelines and instructions for contributing to the project.

## Code of Conduct

- Be respectful and inclusive
- Focus on what's best for the community and the product
- Show empathy towards other contributors
- Accept constructive criticism gracefully

## Getting Started

1. **Fork the repository** on GitHub
2. **Clone your fork** locally:
   ```bash
   git clone https://github.com/YOUR_USERNAME/razberry_beret.git
   cd razberry_beret
   ```
3. **Create a branch** for your changes:
   ```bash
   git checkout -b feature/your-feature-name
   ```

## Development Workflow

### Working with Issues

1. Check the [Project Plan](PROJECT_PLAN.md) to see the current phase and priorities
2. Browse [open issues](https://github.com/yourusername/razberry_beret/issues) 
3. Comment on an issue to indicate you're working on it
4. Reference the issue number in your commits and PR

### Branch Naming Convention

Use descriptive branch names that include the issue number:

- `feature/2-initialize-repo-structure`
- `fix/15-claude-api-timeout`
- `docs/update-architecture`
- `refactor/session-flow`

### Commit Message Guidelines

Follow the conventional commit format:

```
type(scope): brief description

Longer description if needed

Fixes #123
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, no logic change)
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `chore`: Maintenance tasks

**Examples:**
```
feat(backend): add Whisper API integration

Implements voice transcription endpoint using OpenAI Whisper API.
Includes error handling and rate limiting.

Fixes #14
```

```
docs(readme): update setup instructions

Added detailed backend setup steps and environment variables.
```

## Code Standards

### Backend (Node.js/Express)

- Use **ES6+** syntax
- Follow **Airbnb JavaScript Style Guide**
- Use **async/await** over promises where possible
- Always handle errors properly
- Write descriptive variable and function names
- Add JSDoc comments for public APIs
- Keep functions small and focused (single responsibility)

**Example:**
```javascript
/**
 * Generates a question based on user's canon and session context
 * @param {string} userId - The user's unique identifier
 * @param {string} sessionId - Current session identifier
 * @param {string} userResponse - User's previous response
 * @returns {Promise<string>} Generated question from Claude
 */
async function generateQuestion(userId, sessionId, userResponse) {
  try {
    // Implementation
  } catch (error) {
    logger.error('Failed to generate question', { userId, error });
    throw new APIError('Question generation failed', 500);
  }
}
```

### iOS (Swift/SwiftUI)

- Follow **Swift API Design Guidelines**
- Use **SwiftUI** for all UI components
- Follow **MVVM architecture pattern**
- Use **async/await** for asynchronous operations
- Name properties and methods descriptively
- Group related functionality with `// MARK:` comments
- Keep view bodies simple; extract complex logic to ViewModels

**Example:**
```swift
// MARK: - Session View Model
@MainActor
class SessionViewModel: ObservableObject {
    @Published var currentQuestion: String?
    @Published var isRecording: Bool = false
    
    private let sessionService: SessionService
    
    init(sessionService: SessionService) {
        self.sessionService = sessionService
    }
    
    func startRecording() async throws {
        // Implementation
    }
}
```

### Testing

- Write tests for new features
- Maintain or improve code coverage
- Backend: Use Jest for unit tests
- iOS: Use XCTest for unit and UI tests

### Documentation

- Update README.md if adding new setup steps
- Update API documentation for new endpoints
- Add inline comments for complex logic
- Update architecture docs if making architectural changes

## Pull Request Process

1. **Before submitting:**
   - Ensure all tests pass
   - Run linters and fix any issues
   - Update documentation as needed
   - Rebase on latest `main` branch

2. **PR Title Format:**
   ```
   [#IssueNumber] Brief description of changes
   ```
   Example: `[#14] Add Whisper API integration for voice transcription`

3. **PR Description Template:**
   ```markdown
   ## Description
   Brief description of what this PR does
   
   ## Related Issue
   Fixes #14
   
   ## Changes Made
   - Added Whisper API integration
   - Implemented error handling
   - Updated API documentation
   
   ## Testing
   - [ ] Unit tests added/updated
   - [ ] Manual testing completed
   - [ ] Documentation updated
   
   ## Screenshots (if applicable)
   [Add screenshots for UI changes]
   ```

4. **Review Process:**
   - Wait for at least one approval
   - Address review comments
   - Once approved, squash and merge

## Project-Specific Guidelines

### The "Razberry" Misspelling

- **Always** use "Razberry" (with a 'z'), never "Raspberry"
- This is intentional and part of the brand identity
- If AI tools try to correct it, that's a sign of drift (which we're trying to prevent)

### Voice-First Philosophy

- Prioritize voice interactions over text when implementing features
- Keep conversations natural and conversational, not corporate
- The 5-question limit is sacred - don't bypass it

### The Canon is Sacred

- Canon updates are append-only during sessions
- Manual edits must be tracked with audit trails
- Never lose user data - implement proper backups

### Prince Song Diversity

- Maintain the list of 50+ deep cuts (not just hits)
- Ensure randomization truly randomizes
- Track diversity metrics internally

## Environment Setup

### Backend Environment Variables

Create a `.env` file in `/backend`:

```env
# Server
PORT=3000
NODE_ENV=development

# Supabase
SUPABASE_URL=your_supabase_url
SUPABASE_ANON_KEY=your_supabase_anon_key
SUPABASE_SERVICE_KEY=your_supabase_service_key

# Anthropic (Claude)
ANTHROPIC_API_KEY=your_anthropic_api_key

# OpenAI (Whisper)
OPENAI_API_KEY=your_openai_api_key

# Session
SESSION_SECRET=your_session_secret
```

### iOS Configuration

- Xcode 15+
- iOS 17+ target
- Set up proper signing and provisioning profiles
- Configure API endpoints in `Config.swift`

## Getting Help

- **Questions?** Open a [GitHub Discussion](https://github.com/yourusername/razberry_beret/discussions)
- **Bug?** Open an [Issue](https://github.com/yourusername/razberry_beret/issues)
- **Security issue?** Email [security contact TBD]

## Recognition

Contributors will be recognized in:
- GitHub contributors page
- Release notes (for significant contributions)
- Credits in the app (for major features)

## License

By contributing, you agree that your contributions will be licensed under the same license as the project.

---

Thank you for helping build Razberry Beret! 🎸

*Remember: We're building tools that make founders MORE themselves, not more efficient.*

