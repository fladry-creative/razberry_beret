# Razberry Beret - Architecture Documentation

**Last Updated:** October 13, 2025  
**Version:** 0.1 (Pre-Build)

---

## Table of Contents

1. [System Overview](#system-overview)
2. [Architecture Principles](#architecture-principles)
3. [System Components](#system-components)
4. [Data Flow](#data-flow)
5. [Technology Stack](#technology-stack)
6. [Database Schema](#database-schema)
7. [API Design](#api-design)
8. [Security & Privacy](#security--privacy)
9. [Scalability Considerations](#scalability-considerations)
10. [Architecture Decisions](#architecture-decisions)

---

## System Overview

Razberry Beret is a **voice-first, mobile-native application** designed to capture and preserve a founder's authentic brand identity (The Canon) through AI-facilitated conversational sessions.

### High-Level Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    iOS App (Swift/SwiftUI)               │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐ │
│  │  Recording   │  │   Session    │  │    Canon     │ │
│  │     UI       │  │  Management  │  │   Viewer     │ │
│  └──────────────┘  └──────────────┘  └──────────────┘ │
└─────────────────────────────────────────────────────────┘
                            │
                            │ HTTPS / REST API
                            ▼
┌─────────────────────────────────────────────────────────┐
│              Backend API (Node.js/Express)               │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐ │
│  │    Auth      │  │   Session    │  │    Canon     │ │
│  │  Endpoints   │  │  Controller  │  │  Processing  │ │
│  └──────────────┘  └──────────────┘  └──────────────┘ │
└─────────────────────────────────────────────────────────┘
           │                    │                  │
           │                    │                  │
           ▼                    ▼                  ▼
┌──────────────────┐  ┌──────────────────┐  ┌──────────────────┐
│    Supabase      │  │   Anthropic API  │  │   OpenAI API     │
│  (Auth + DB)     │  │ (Claude Sonnet)  │  │    (Whisper)     │
└──────────────────┘  └──────────────────┘  └──────────────────┘
```

---

## Architecture Principles

### 1. Voice-First Design
- Voice is the primary input method (not an afterthought)
- Optimized for "dead time" usage (waiting, commuting)
- Minimal friction from opening app to speaking

### 2. Constrained Interactions
- **5-question hard limit** per session (prevents drift)
- **1:1 exchange pattern** (no AI monologues)
- **Voice-only input** during capture (authenticity preservation)

### 3. Canon Integrity
- **Append-only** during sessions (no live edits)
- Manual edits tracked with audit trails
- Structured but not prescriptive categorization

### 4. Privacy by Design
- End-to-end encryption
- User owns their data completely
- No social features (Canon is private)
- Optional local-only mode

### 5. Drift Detection
- Prince song diversity as a canary metric
- Internal monitoring of consensus trends
- Transparent quality indicators

---

## System Components

### iOS Application

**Architecture Pattern:** MVVM (Model-View-ViewModel)

#### Core Modules

1. **Authentication Module**
   - Supabase Auth integration
   - Biometric authentication (Face ID/Touch ID)
   - Session token management

2. **Recording Module**
   - AVFoundation for audio capture
   - Real-time audio level monitoring
   - Optimized for background recording

3. **Transcription Module**
   - Whisper API client
   - Near-real-time transcription
   - Error handling and retry logic

4. **Session Management**
   - 5-question flow controller
   - State machine for session progression
   - Automatic session persistence

5. **Canon Module**
   - Local caching for offline viewing
   - Search and filtering
   - Category navigation
   - Export functionality (PDF/Markdown)

6. **Notification System**
   - "Dead time" reminder scheduling
   - Local notifications (no push needed)
   - Intelligent scheduling based on usage patterns

#### Key Design Patterns

- **Repository Pattern:** Data layer abstraction
- **Coordinator Pattern:** Navigation flow management
- **Dependency Injection:** Service composition
- **Reactive Programming:** Combine framework for data binding

### Backend API

**Framework:** Express.js (Node.js)

#### Service Architecture

```
Controllers (Routes)
      │
      ▼
Services (Business Logic)
      │
      ▼
Repositories (Data Access)
      │
      ▼
External APIs / Database
```

#### Core Services

1. **Authentication Service**
   - Supabase Auth integration
   - JWT token validation
   - User session management

2. **Session Service**
   - Session CRUD operations
   - Question generation orchestration
   - Session state tracking

3. **Transcription Service**
   - Whisper API integration
   - Audio file handling
   - Transcription result processing

4. **Claude Service**
   - Question generation
   - Canon analysis for question targeting
   - Session recap generation

5. **Canon Service**
   - Raw transcript storage
   - Structured extraction
   - Categorization and tagging
   - Search indexing

6. **Prince Song Service**
   - Song recommendation logic
   - Diversity tracking
   - Rating aggregation

7. **Analytics Service**
   - Session metrics
   - Canon coverage tracking
   - Drift detection metrics

---

## Data Flow

### Session Flow (End-to-End)

```
1. User opens app
   │
   ▼
2. iOS app authenticates with backend
   │
   ▼
3. User starts recording
   │
   ▼
4. Audio captured via AVFoundation
   │
   ▼
5. Audio sent to backend → Whisper API
   │
   ▼
6. Transcription returned to iOS app
   │
   ▼
7. Backend sends transcription to Claude API
   │
   ▼
8. Claude generates next question
   │
   ▼
9. Question displayed in iOS app
   │
   ▼
10. Repeat steps 3-9 (max 5 times)
   │
   ▼
11. Backend processes canon updates
   │
   ▼
12. Prince song recommendation generated
   │
   ▼
13. Session recap + song sent to iOS
   │
   ▼
14. Canon synced to iOS for viewing
```

### Canon Update Flow

```
Session completes
   │
   ▼
Raw transcript saved to database
   │
   ▼
Claude API: Extract structured insights
   │
   ▼
Auto-categorize insights
   │
   ▼
Append to user's canon
   │
   ▼
Update search index
   │
   ▼
Sync to iOS client
```

---

## Technology Stack

### Backend

| Component | Technology | Rationale |
|-----------|-----------|-----------|
| Runtime | Node.js 18+ | JavaScript ecosystem, async I/O |
| Framework | Express.js | Lightweight, well-documented, flexible |
| Database | PostgreSQL (via Supabase) | Relational data with JSON support |
| Authentication | Supabase Auth | Built-in, secure, mobile-friendly |
| ORM/Query Builder | Supabase JS Client | Type-safe, real-time capabilities |
| API Documentation | OpenAPI/Swagger | Standard, auto-generated docs |
| Testing | Jest + Supertest | Comprehensive, fast, well-supported |
| Logging | Winston | Structured logging, multiple transports |

### iOS

| Component | Technology | Rationale |
|-----------|-----------|-----------|
| Language | Swift 5.9+ | Modern, safe, performant |
| UI Framework | SwiftUI | Declarative, future of iOS development |
| Architecture | MVVM | Testable, separation of concerns |
| Networking | URLSession + async/await | Native, modern concurrency |
| Audio | AVFoundation | Native, low-level control |
| Local Storage | SwiftData | Modern, type-safe persistence |
| Reactive | Combine | Native reactive framework |
| Testing | XCTest | Native testing framework |

### AI/ML Services

| Service | Provider | Purpose |
|---------|----------|---------|
| Question Generation | Anthropic Claude Sonnet 4.5 | Natural conversation, long context |
| Voice Transcription | OpenAI Whisper API | Accurate, multi-lingual support |
| Canon Structuring | Claude Sonnet 4.5 | Intelligent categorization |
| Session Recap | Claude Sonnet 4.5 | Summarization |

### Infrastructure

| Component | Technology | Rationale |
|-----------|-----------|-----------|
| Hosting | Vercel / Railway | Easy deployment, auto-scaling |
| Database | Supabase (managed Postgres) | Full-stack backend as a service |
| File Storage | Supabase Storage | Audio files, exports |
| CI/CD | GitHub Actions | Integrated with repository |
| Monitoring | Sentry | Error tracking |
| Analytics | PostHog | Privacy-focused analytics |

---

## Database Schema

### Core Tables

#### `users`
```sql
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  email TEXT UNIQUE NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  subscription_tier TEXT DEFAULT 'free',
  total_sessions INT DEFAULT 0,
  settings JSONB DEFAULT '{}'
);
```

#### `sessions`
```sql
CREATE TABLE sessions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  completed_at TIMESTAMPTZ,
  status TEXT DEFAULT 'in_progress', -- in_progress, completed, abandoned
  question_count INT DEFAULT 0,
  prince_song_id UUID REFERENCES prince_songs(id),
  recap TEXT,
  metadata JSONB DEFAULT '{}'
);
```

#### `exchanges`
```sql
CREATE TABLE exchanges (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  session_id UUID REFERENCES sessions(id) ON DELETE CASCADE,
  question_number INT NOT NULL,
  question TEXT NOT NULL,
  user_response TEXT NOT NULL,
  transcription_confidence FLOAT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  audio_file_url TEXT
);
```

#### `canon_entries`
```sql
CREATE TABLE canon_entries (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  category TEXT NOT NULL, -- mission, voice, principles, etc.
  content TEXT NOT NULL,
  source_session_id UUID REFERENCES sessions(id),
  source_exchange_id UUID REFERENCES exchanges(id),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  manually_edited BOOLEAN DEFAULT FALSE,
  audit_trail JSONB DEFAULT '[]'
);

CREATE INDEX idx_canon_entries_user_id ON canon_entries(user_id);
CREATE INDEX idx_canon_entries_category ON canon_entries(category);
```

#### `prince_songs`
```sql
CREATE TABLE prince_songs (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  title TEXT NOT NULL,
  album TEXT,
  year INT,
  is_deep_cut BOOLEAN DEFAULT TRUE,
  spotify_url TEXT,
  reasoning_template TEXT
);
```

#### `song_recommendations`
```sql
CREATE TABLE song_recommendations (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  session_id UUID REFERENCES sessions(id) ON DELETE CASCADE,
  song_id UUID REFERENCES prince_songs(id),
  reasoning TEXT,
  user_rating INT, -- 1 (thumbs down) or 2 (thumbs up)
  created_at TIMESTAMPTZ DEFAULT NOW()
);
```

#### `analytics_events`
```sql
CREATE TABLE analytics_events (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  event_type TEXT NOT NULL,
  event_data JSONB DEFAULT '{}',
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_analytics_events_user_id ON analytics_events(user_id);
CREATE INDEX idx_analytics_events_type ON analytics_events(event_type);
CREATE INDEX idx_analytics_events_created_at ON analytics_events(created_at);
```

### Relationships

```
users (1) ──< (many) sessions
sessions (1) ──< (many) exchanges
sessions (1) ──< (many) canon_entries
sessions (1) ──< (1) song_recommendations
prince_songs (1) ──< (many) song_recommendations
users (1) ──< (many) canon_entries
```

---

## API Design

### RESTful Endpoints

#### Authentication
```
POST   /api/v1/auth/register
POST   /api/v1/auth/login
POST   /api/v1/auth/logout
GET    /api/v1/auth/me
```

#### Sessions
```
POST   /api/v1/sessions                # Start new session
GET    /api/v1/sessions                # List user's sessions
GET    /api/v1/sessions/:id            # Get session details
PATCH  /api/v1/sessions/:id            # Update session
DELETE /api/v1/sessions/:id            # Delete session
```

#### Exchanges (within sessions)
```
POST   /api/v1/sessions/:id/exchanges  # Submit response, get next question
GET    /api/v1/sessions/:id/exchanges  # List exchanges in session
```

#### Transcription
```
POST   /api/v1/transcribe               # Upload audio, get transcription
```

#### Canon
```
GET    /api/v1/canon                    # Get user's full canon
GET    /api/v1/canon/categories         # Get canon by category
GET    /api/v1/canon/search?q=         # Search canon
PATCH  /api/v1/canon/:id                # Manually edit canon entry
POST   /api/v1/canon/export             # Export canon (PDF/Markdown)
```

#### Prince Songs
```
GET    /api/v1/songs                    # List all songs
POST   /api/v1/recommendations/:id/rate # Rate a song recommendation
```

### API Response Format

**Success Response:**
```json
{
  "success": true,
  "data": { /* response data */ },
  "meta": {
    "timestamp": "2025-10-13T12:00:00Z"
  }
}
```

**Error Response:**
```json
{
  "success": false,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Invalid input data",
    "details": { /* field-specific errors */ }
  },
  "meta": {
    "timestamp": "2025-10-13T12:00:00Z"
  }
}
```

---

## Security & Privacy

### Authentication & Authorization

1. **Supabase Auth Integration**
   - JWT-based authentication
   - Refresh token rotation
   - Rate limiting on auth endpoints

2. **Row-Level Security (RLS)**
   - Postgres RLS policies enforce user data isolation
   - Users can only access their own data

3. **API Security**
   - HTTPS only (TLS 1.3)
   - CORS configured for iOS app only
   - Rate limiting (per user, per endpoint)
   - Request signing for sensitive operations

### Data Privacy

1. **Encryption**
   - Data at rest: AES-256 (Supabase default)
   - Data in transit: TLS 1.3
   - Audio files: Encrypted in storage

2. **Data Retention**
   - Raw audio: 30 days (configurable by user)
   - Transcriptions: Indefinite (until user deletion)
   - Analytics: Aggregated, no PII

3. **User Rights**
   - Export all data (GDPR compliance)
   - Delete all data (right to be forgotten)
   - Opt-out of analytics
   - View access logs

### API Key Management

- Anthropic API key: Server-side only, environment variable
- OpenAI API key: Server-side only, environment variable
- Supabase keys: Anon key in iOS app, service key server-side only

---

## Scalability Considerations

### Current Architecture (V1)

- Expected load: < 1,000 users
- Sessions per day: ~3,000
- API requests per day: ~50,000
- Database size: < 10 GB

**Sufficient:** Serverless functions + managed database

### Future Scaling (V2+)

#### Bottlenecks to Watch

1. **Claude API Costs**
   - Cost per question: ~$0.01-0.05
   - Mitigation: Caching common question patterns, prompt optimization

2. **Whisper API Latency**
   - Transcription time: 1-3 seconds
   - Mitigation: Stream audio in chunks, pre-warm API connections

3. **Database Queries**
   - Canon search across large datasets
   - Mitigation: Full-text search indexes, read replicas

4. **File Storage**
   - Audio files accumulate quickly
   - Mitigation: Lifecycle policies (delete after 30 days), compression

#### Scaling Strategies

- **Horizontal scaling:** Serverless auto-scales
- **Caching:** Redis for session state, frequent queries
- **CDN:** Static assets, exported Canons
- **Database:** Read replicas for analytics queries

---

## Architecture Decisions

### ADR-001: Why Supabase over Custom Backend?

**Decision:** Use Supabase for auth, database, and storage

**Context:** Need fast MVP development with robust security

**Rationale:**
- Built-in authentication (email, OAuth, magic links)
- Row-level security out of the box
- Real-time capabilities (future feature)
- Generous free tier for initial launch
- Reduces infrastructure management

**Trade-offs:**
- Vendor lock-in (mitigated by standard PostgreSQL)
- Less control over database tuning

---

### ADR-002: Why Claude Sonnet 4.5 over GPT-4?

**Decision:** Use Claude Sonnet 4.5 for question generation

**Context:** Need conversational, context-aware questions

**Rationale:**
- 200K token context window (entire canon + session)
- Excellent at following constraints (1:1 exchange format)
- More "human" conversational style
- Lower latency than GPT-4 Turbo

**Trade-offs:**
- Slightly higher cost than GPT-3.5
- Less mainstream (developer familiarity)

---

### ADR-003: iOS-Only for V1

**Decision:** Build native iOS app only (no Android, web)

**Context:** Limited resources, need to validate concept

**Rationale:**
- Target audience is iPhone users (founders with AirPods)
- Native iOS provides best voice recording experience
- SwiftUI accelerates development
- TestFlight simplifies beta testing
- App Store is primary distribution channel

**Trade-offs:**
- Excludes Android users (~30% of US market)
- No cross-platform code reuse

**Future:** React Native or Flutter for V2 if validated

---

### ADR-004: Voice-Only Input During Sessions

**Decision:** No text input option during active sessions

**Context:** Preserve authenticity of founder's voice

**Rationale:**
- Typing encourages "editing" thoughts = less authentic
- Voice captures emotion, energy, cadence
- Enforces "dead time" use case (hands-free)
- Differentiates from note-taking apps

**Trade-offs:**
- Accessibility concern (mitigated: can edit Canon after)
- May frustrate users in noisy environments

---

### ADR-005: 5-Question Hard Limit

**Decision:** Sessions max out at exactly 5 questions

**Context:** Prevent drift, keep sessions tight

**Rationale:**
- Fits into typical "dead time" windows (5-10 minutes)
- Prevents AI from dominating the conversation
- Forces quality over quantity
- Creates consistent session length for analytics

**Trade-offs:**
- May feel arbitrary to users
- Some sessions may need more depth

---

### ADR-006: Append-Only Canon During Sessions

**Decision:** Canon cannot be edited during active sessions

**Context:** Maintain data integrity, audit trail

**Rationale:**
- Prevents real-time "cleaning up" (defeats authenticity)
- Clear separation between capture and curation
- Simplifies sync logic
- Enables Canon diff view

**Trade-offs:**
- Users must wait until after session to fix mistakes
- Transcription errors persist in raw data

---

## Future Architecture Considerations

### V2 Features Requiring Architecture Changes

1. **Team Canon (Multi-user)**
   - Shared canon with conflict resolution
   - Role-based access control
   - Canon merging and versioning

2. **Drift Detection**
   - ML pipeline to compare external text to canon
   - Similarity scoring service
   - Real-time analysis endpoint

3. **Canon API (External Access)**
   - Public API for third-party integrations
   - OAuth for external apps
   - Rate limiting per API key

4. **Offline Mode**
   - Local-only canon storage
   - Background sync when online
   - Conflict resolution

---

## References

- [Supabase Documentation](https://supabase.com/docs)
- [Anthropic Claude API](https://docs.anthropic.com)
- [OpenAI Whisper API](https://platform.openai.com/docs/guides/speech-to-text)
- [SwiftUI Guidelines](https://developer.apple.com/design/human-interface-guidelines/swiftui)
- [Express.js Best Practices](https://expressjs.com/en/advanced/best-practice-performance.html)

---

**Document Status:** Living document, updated as architecture evolves.

**Next Review:** After Phase 1 completion

