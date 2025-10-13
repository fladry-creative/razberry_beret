# Razberry Beret 🎸

> *Don't let AI turn you into a statistically average founder.*

**Razberry Beret** is a voice-first iPhone app that captures your canonical truth *before* AI can dilute it. Through constrained, conversational exchanges during dead time, founders build an immutable brand bible that serves as the primary source for all future AI interactions.

## The Problem

Every founder using AI in 2025 is unknowingly building a company that's 60% their truth and 40% statistical consensus. AI tools trained on trillions of tokens pull entrepreneurs toward "what companies like yours usually do" - turning unique visions into generic, averaged-out versions of themselves.

**This is AI drift.** And by the time you notice it, your brand voice, your product positioning, and your company identity have already been homogenized.

## The Solution

Razberry Beret helps founders build their **Canon** - a living brand bible that captures their authentic vision, voice, and principles through:

- 🎤 **Voice-first capture sessions** (5 questions max, during dead time)
- 🤖 **Claude Sonnet 4.5** for intelligent, conversational questioning  
- 📚 **The Canon** - your structured, searchable brand source code
- 🎵 **Prince song recommendations** - a canary system to detect AI drift

## Why "Razberry" (Intentionally Misspelled)?

The misspelling is the point. We're not the consensus choice. We embrace human imperfection over AI perfection. If AI ever "corrects" it, we know drift is happening.

## Project Structure

```
razberry_beret/
├── docs/           # Documentation and architecture decisions
├── backend/        # Node.js/Express API + Supabase
├── ios/            # Swift/SwiftUI iPhone app
├── PROJECT_PLAN.md # Implementation roadmap
└── README.md       # This file
```

## Technology Stack

### Backend
- **Runtime:** Node.js + Express
- **Database:** Supabase (PostgreSQL)
- **Authentication:** Supabase Auth
- **AI/ML:** 
  - Claude Sonnet 4.5 (Anthropic API)
  - OpenAI Whisper API (voice transcription)

### iOS
- **Platform:** iOS 17+ only
- **Framework:** SwiftUI
- **Language:** Swift
- **Voice:** AVFoundation + Whisper API

## Core Features (V1)

1. **Voice Capture Sessions**
   - 5 questions maximum per session
   - 1:1 conversational exchange (no AI paragraphs)
   - Voice-only input to capture authentic voice
   - Designed for "dead time" (waiting, commuting)

2. **The Canon**
   - Append-only during sessions
   - Auto-categorized by topic (mission, voice, principles, etc.)
   - Searchable and exportable (PDF/Markdown)
   - Shows last updated dates

3. **Prince Song Canary**
   - Song recommendation after each session
   - Quality control mechanism to detect AI drift
   - Tracks diversity of recommendations

## Development Phases

### Phase 1: Foundation & Setup (Issues #1-10) 🏗️
Setting up the infrastructure, tech stack, and basic project structure.

### Phase 2: Backend API (Issues #11-20) 
Core API endpoints for authentication, sessions, Canon storage, and AI integrations.

### Phase 3: iOS App - Core UI (Issues #21-30)
Building the native iOS interface and navigation.

### Phase 4: Core Features (Issues #31-40)
Implementing voice recording, transcription, and the 5-question session flow.

### Phase 5: Polish & Features (Issues #41-50)
Adding animations, offline mode, exports, and analytics.

### Phase 6: Testing & Launch (Issues #51-55)
Quality assurance, beta testing, and App Store submission.

## Getting Started

### Prerequisites
- Node.js 18+ and npm
- Xcode 15+ (for iOS development)  
- iOS 17.0+ (deployment target)
- Supabase account
- Anthropic API key (Claude Sonnet 4.5)
- OpenAI API key (Whisper)

### Setup

```bash
# Clone the repository
git clone https://github.com/yourusername/razberry_beret.git
cd razberry_beret

# Backend setup
cd backend
npm install
cp .env.example .env
# Edit .env with your API keys
npm run dev

# iOS setup
cd ../ios
# Open RazberryBeret.xcodeproj in Xcode 15+
# Build and run on iOS 17.0+ simulator or device
```

More detailed setup instructions coming soon as development progresses.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines on how to contribute to this project.

## Documentation

- [Architecture Decisions](docs/ARCHITECTURE.md)
- [API Documentation](docs/API.md) *(coming soon)*
- [iOS App Guide](docs/IOS_GUIDE.md) *(coming soon)*

## Success Metrics

**North Star Metric:** Canon Density Score = (# of structured insights captured) / (# of sessions completed)

Target: 8-12 insights per session

### Engagement Targets
- D7 Retention: 70%
- D30 Retention: 40%
- Session Frequency: 3+ per week
- Session Completion: 85%+

### The Canary Metric 🐦
Internal tracking of Prince song diversity. If "Raspberry Beret" appears in >10% of sessions, investigate for AI drift.

## License

[License TBD]

## Contact

For questions or feedback: [Contact info TBD]

---

**Let's build this.** 🚀

*Stay yourself while scaling with AI.*

