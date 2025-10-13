#!/bin/bash

# Razberry Beret - GitHub Issue Creation Script
# This script creates all project issues in GitHub

cd /Users/robbfladry/Dev/razberry_beret

echo "Creating GitHub issues for Razberry Beret..."

# Phase 1: Foundation & Setup
gh issue create --title "Initialize repository structure and documentation" --body "**Phase 1: Foundation & Setup**

Create proper repository structure:
- Create /docs directory
- Create /backend directory
- Create /ios directory  
- Add README.md with project overview
- Add CONTRIBUTING.md
- Add .gitignore for Node.js and Swift
- Document architecture decisions

**Acceptance Criteria:**
- [ ] Directory structure created
- [ ] README with project description
- [ ] Basic documentation in place" --label "phase-1,setup"

gh issue create --title "Set up backend technology stack (Node.js/Express + Supabase)" --body "**Phase 1: Foundation & Setup**

Initialize backend with:
- Node.js + Express server
- TypeScript configuration
- Supabase project setup
- Environment variable management (.env)
- Basic health check endpoint

**Tech Stack:**
- Node.js 20+
- Express.js
- TypeScript
- Supabase (Auth + Database)

**Acceptance Criteria:**
- [ ] Express server runs on localhost:3000
- [ ] TypeScript compilation works
- [ ] Supabase project connected
- [ ] /health endpoint responds" --label "phase-1,backend"

gh issue create --title "Configure Anthropic API integration (Claude Sonnet 4.5)" --body "**Phase 1: Foundation & Setup**

Set up Anthropic API for question generation:
- Install @anthropic-ai/sdk
- Create API service wrapper
- Implement error handling and retries
- Add rate limiting
- Test basic message generation

**Acceptance Criteria:**
- [ ] Anthropic SDK installed and configured
- [ ] Service wrapper with proper types
- [ ] Test script validates API connectivity
- [ ] Error handling implemented" --label "phase-1,backend,ai"

gh issue create --title "Set up OpenAI Whisper API for voice transcription" --body "**Phase 1: Foundation & Setup**

Integrate Whisper for voice-to-text:
- Install OpenAI SDK
- Create transcription service
- Handle audio file formats (m4a, wav)
- Implement streaming if possible
- Add error handling

**Acceptance Criteria:**
- [ ] OpenAI SDK configured
- [ ] Transcription endpoint working
- [ ] Supports common audio formats
- [ ] Error handling for failed transcriptions" --label "phase-1,backend,voice"

gh issue create --title "Design and implement database schema (users, sessions, canon)" --body "**Phase 1: Foundation & Setup**

Create Postgres database schema:

**Tables:**
- users (id, email, created_at, settings)
- sessions (id, user_id, created_at, completed_at, question_count)
- session_exchanges (id, session_id, question, answer, transcript)
- canon_entries (id, user_id, category, content, source_session_id, created_at)
- prince_songs (id, title, album, year, deep_cut_score)

**Acceptance Criteria:**
- [ ] Migration files created
- [ ] Schema applied to Supabase
- [ ] Foreign keys and indexes configured
- [ ] Seed data for prince_songs" --label "phase-1,backend,database"

gh issue create --title "Implement authentication system (Supabase Auth)" --body "**Phase 1: Foundation & Setup**

Set up user authentication:
- Configure Supabase Auth
- Email/password login
- JWT token handling
- Auth middleware for Express
- Session management

**Acceptance Criteria:**
- [ ] Supabase Auth configured
- [ ] Registration endpoint
- [ ] Login endpoint
- [ ] Auth middleware protects routes
- [ ] Token refresh logic" --label "phase-1,backend,auth"

gh issue create --title "Create iOS project (Swift + SwiftUI)" --body "**Phase 1: Foundation & Setup**

Initialize iOS application:
- Create new Xcode project
- Set up SwiftUI
- Configure app bundle identifier (com.fladrycreative.razberryberet)
- Set minimum iOS version to 17.0
- Configure app icons and launch screen

**Acceptance Criteria:**
- [ ] Xcode project created
- [ ] SwiftUI app structure
- [ ] App runs on simulator
- [ ] Basic navigation in place" --label "phase-1,ios"

gh issue create --title "Configure development environment and build scripts" --body "**Phase 1: Foundation & Setup**

Set up development tooling:
- package.json scripts (dev, build, test)
- Backend hot-reloading (nodemon)
- Environment variable templates
- Docker setup (optional)
- Development documentation

**Acceptance Criteria:**
- [ ] npm run dev starts backend
- [ ] Hot reloading works
- [ ] .env.example provided
- [ ] Setup instructions in README" --label "phase-1,setup"

gh issue create --title "Set up CI/CD pipeline basics" --body "**Phase 1: Foundation & Setup**

Create GitHub Actions workflows:
- Backend linting and tests
- iOS build validation
- Automated issue labeling
- Branch protection rules

**Acceptance Criteria:**
- [ ] .github/workflows created
- [ ] Backend CI runs on PR
- [ ] iOS build validates
- [ ] Status checks configured" --label "phase-1,devops"

gh issue create --title "Create Prince song database (50 deep cuts)" --body "**Phase 1: Foundation & Setup**

Curate Prince song collection:
- Research 50+ Prince songs (focus on deep cuts)
- Create JSON seed file with:
  - Title
  - Album
  - Year
  - Mood/emotion tags
  - Deep cut score (1-10)
- Load into database

**Song Distribution:**
- 10% mainstream (Purple Rain, etc.)
- 90% deep cuts (Alphabet St., Batdance, etc.)

**Acceptance Criteria:**
- [ ] 50+ songs researched
- [ ] Seed file created
- [ ] Songs loaded to database
- [ ] Diversity validated" --label "phase-1,content"

# Phase 2: Backend API
gh issue create --title "Implement user registration/login endpoints" --body "**Phase 2: Backend API**

Create user auth endpoints:

**Endpoints:**
- POST /api/auth/register
- POST /api/auth/login
- POST /api/auth/logout
- GET /api/auth/me

**Acceptance Criteria:**
- [ ] Registration with email validation
- [ ] Login returns JWT
- [ ] Protected endpoints work
- [ ] Error handling for invalid credentials" --label "phase-2,backend,auth"

gh issue create --title "Create session management API endpoints" --body "**Phase 2: Backend API**

Build session CRUD operations:

**Endpoints:**
- POST /api/sessions (start new session)
- GET /api/sessions/:id
- GET /api/sessions (list user sessions)
- PUT /api/sessions/:id/complete
- DELETE /api/sessions/:id

**Acceptance Criteria:**
- [ ] Sessions can be created
- [ ] Sessions can be retrieved
- [ ] Session completion tracked
- [ ] User can only access own sessions" --label "phase-2,backend"

gh issue create --title "Build voice transcription endpoint (Whisper integration)" --body "**Phase 2: Backend API**

Create transcription service:

**Endpoint:**
- POST /api/transcribe (accepts audio file)

**Features:**
- Accept m4a, wav formats
- Return transcript + confidence score
- Handle errors gracefully
- Log transcription quality

**Acceptance Criteria:**
- [ ] Endpoint accepts audio files
- [ ] Returns accurate transcription
- [ ] Error handling for poor audio
- [ ] Response time < 3 seconds" --label "phase-2,backend,voice"

gh issue create --title "Implement Claude question generation service" --body "**Phase 2: Backend API**

Build intelligent question generator:

**Endpoint:**
- POST /api/questions/generate

**Input:**
- User's existing canon
- Current session context
- Previous Q&A in session

**Logic:**
- Analyze canon gaps
- Generate contextual questions
- Enforce 1:1 constraint
- Maximum 5 questions per session

**Acceptance Criteria:**
- [ ] Questions are contextual
- [ ] No AI \"suggestions\" during capture
- [ ] Questions feel conversational
- [ ] Response time < 2 seconds" --label "phase-2,backend,ai"

gh issue create --title "Create Canon storage and retrieval API" --body "**Phase 2: Backend API**

Build Canon management:

**Endpoints:**
- GET /api/canon (retrieve user's canon)
- GET /api/canon/category/:category
- POST /api/canon/entry (manual addition)
- PUT /api/canon/entry/:id (manual edit)
- GET /api/canon/search?q=query

**Acceptance Criteria:**
- [ ] Canon retrieved by user
- [ ] Category filtering works
- [ ] Manual edits have audit trail
- [ ] Search functionality" --label "phase-2,backend"

gh issue create --title "Build Canon structuring/categorization logic" --body "**Phase 2: Backend API**

Implement AI-powered categorization:

**Categories:**
- Mission/Vision
- Product Principles
- Brand Voice
- Founding Story
- Non-negotiables
- Aesthetic Preferences
- Customer Philosophy
- Competitive Positioning

**Process:**
- Batch process every 24 hours
- Use Claude to categorize entries
- Extract key insights
- Auto-tag content

**Acceptance Criteria:**
- [ ] Batch job categorizes entries
- [ ] Categories are accurate
- [ ] Manual override possible
- [ ] Performance optimized" --label "phase-2,backend,ai"

gh issue create --title "Implement Prince song recommendation engine" --body "**Phase 2: Backend API**

Build song recommendation logic:

**Endpoint:**
- POST /api/sessions/:id/song

**Algorithm:**
- Analyze session tone/emotion
- Match to song mood tags
- Bias toward deep cuts (90%)
- Track recommendations to avoid repetition
- Log for drift detection

**Acceptance Criteria:**
- [ ] Songs match session mood
- [ ] 90%+ deep cuts recommended
- [ ] No immediate repeats
- [ ] Reasoning provided" --label "phase-2,backend,ai"

gh issue create --title "Create session analytics tracking" --body "**Phase 2: Backend API**

Implement analytics:

**Metrics to Track:**
- Session completion rate
- Questions per session
- Canon density score
- Prince song diversity
- User retention (D1, D7, D30)

**Endpoints:**
- GET /api/analytics/user/:id
- GET /api/analytics/system (admin)

**Acceptance Criteria:**
- [ ] All metrics tracked
- [ ] Analytics dashboard data ready
- [ ] Performance efficient
- [ ] Privacy-respecting" --label "phase-2,backend,analytics"

gh issue create --title "Add Canon export functionality (PDF/Markdown)" --body "**Phase 2: Backend API**

Enable Canon export:

**Endpoints:**
- GET /api/canon/export?format=pdf
- GET /api/canon/export?format=markdown

**Features:**
- PDF generation with formatting
- Markdown with proper structure
- Include metadata (dates, categories)
- Downloadable file response

**Acceptance Criteria:**
- [ ] PDF export works
- [ ] Markdown export works
- [ ] Formatting is clean
- [ ] Files are downloadable" --label "phase-2,backend"

gh issue create --title "Implement API rate limiting and error handling" --body "**Phase 2: Backend API**

Add production-ready features:

**Rate Limiting:**
- 100 requests per hour per user
- Different limits for different endpoints
- Proper 429 responses

**Error Handling:**
- Consistent error format
- Proper HTTP status codes
- Error logging
- User-friendly messages

**Acceptance Criteria:**
- [ ] Rate limiting active
- [ ] Errors are consistent
- [ ] Logging configured
- [ ] API documentation updated" --label "phase-2,backend"

# Phase 3: iOS App - Core UI
gh issue create --title "Design app architecture (MVVM pattern)" --body "**Phase 3: iOS App - Core UI**

Establish iOS architecture:

**Pattern:** MVVM (Model-View-ViewModel)

**Structure:**
- Models/ (data models)
- Views/ (SwiftUI views)
- ViewModels/ (business logic)
- Services/ (API, audio, etc.)
- Utilities/ (helpers)

**Acceptance Criteria:**
- [ ] Folder structure created
- [ ] Base classes/protocols defined
- [ ] Dependency injection setup
- [ ] Example view implemented" --label "phase-3,ios,architecture"

gh issue create --title "Create onboarding flow screens" --body "**Phase 3: iOS App - Core UI**

Build first-time user experience:

**Screens:**
1. Welcome (30-sec explainer)
2. Microphone permission request
3. First session setup
4. Dead time reminder setup (optional)

**Design:**
- Clean, minimal UI
- Clear value proposition
- Easy to skip optional steps

**Acceptance Criteria:**
- [ ] All screens designed
- [ ] Navigation flow works
- [ ] Permissions handled
- [ ] Can skip to app" --label "phase-3,ios,ui"

gh issue create --title "Build home screen and navigation" --body "**Phase 3: iOS App - Core UI**

Create main navigation:

**Home Screen:**
- \"Start Session\" button (prominent)
- Recent sessions list
- \"View Canon\" button
- Settings icon

**Navigation:**
- Tab bar or custom navigation
- Smooth transitions
- Back navigation

**Acceptance Criteria:**
- [ ] Home screen designed
- [ ] Navigation functional
- [ ] All sections accessible
- [ ] iOS design guidelines followed" --label "phase-3,ios,ui"

gh issue create --title "Implement authentication screens (login/signup)" --body "**Phase 3: iOS App - Core UI**

Build auth UI:

**Screens:**
- Login
- Signup
- Password reset

**Features:**
- Email validation
- Password requirements
- Loading states
- Error messages
- Biometric login (Face ID)

**Acceptance Criteria:**
- [ ] Auth screens designed
- [ ] Form validation works
- [ ] API integration complete
- [ ] Secure token storage" --label "phase-3,ios,ui,auth"

gh issue create --title "Create session recording interface" --body "**Phase 3: iOS App - Core UI**

Build voice session UI:

**Components:**
- Recording button (animated)
- Waveform visualization
- Question display
- Transcript display (real-time)
- Session progress (1/5, 2/5, etc.)

**States:**
- Listening
- Processing
- Waiting for user
- Complete

**Acceptance Criteria:**
- [ ] Recording UI intuitive
- [ ] Visual feedback clear
- [ ] Progress visible
- [ ] Accessible design" --label "phase-3,ios,ui,voice"

gh issue create --title "Build real-time transcription display" --body "**Phase 3: iOS App - Core UI**

Show transcription as user speaks:

**Features:**
- Real-time text update
- Word-by-word appearance
- Confidence indicator (optional)
- Edit capability before sending

**UX:**
- Smooth animations
- Readable font
- Scrollable for long responses

**Acceptance Criteria:**
- [ ] Transcription appears in real-time
- [ ] User can edit before submit
- [ ] Performance is smooth
- [ ] Text is readable" --label "phase-3,ios,ui,voice"

gh issue create --title "Design and implement Canon viewing interface" --body "**Phase 3: iOS App - Core UI**

Build Canon browser:

**Features:**
- Clean, scrollable document
- Category sections (collapsible)
- Search bar
- Last updated dates
- Export button

**Design:**
- Book-like aesthetic
- Easy to read
- Quick navigation
- Share functionality

**Acceptance Criteria:**
- [ ] Canon displays beautifully
- [ ] Categories organized
- [ ] Search works
- [ ] Export accessible" --label "phase-3,ios,ui"

gh issue create --title "Create Canon search and filtering" --body "**Phase 3: iOS App - Core UI**

Add Canon navigation features:

**Search:**
- Full-text search
- Instant results
- Highlighting matches

**Filters:**
- By category
- By date range
- By source session

**Acceptance Criteria:**
- [ ] Search is fast
- [ ] Filters work correctly
- [ ] Results are relevant
- [ ] UI is intuitive" --label "phase-3,ios,ui"

gh issue create --title "Build settings screen" --body "**Phase 3: iOS App - Core UI**

Create app settings:

**Options:**
- Account management
- Notification preferences
- Dead time windows
- Audio quality settings
- Privacy settings
- Export data
- Delete account

**Acceptance Criteria:**
- [ ] All settings functional
- [ ] Changes persist
- [ ] Account deletion works
- [ ] Privacy respected" --label "phase-3,ios,ui"

gh issue create --title "Implement notification system for dead time reminders" --body "**Phase 3: iOS App - Core UI**

Build smart reminders:

**Features:**
- Configure time windows
- Frequency settings
- Smart notifications (respect DND)
- Quick action from notification

**UX:**
- Non-intrusive
- Easy to configure
- Can be disabled

**Acceptance Criteria:**
- [ ] Notifications send correctly
- [ ] Time windows respected
- [ ] Quick actions work
- [ ] Can be disabled" --label "phase-3,ios,notifications"

# Phase 4: Core Features
gh issue create --title "Implement voice recording with AVFoundation" --body "**Phase 4: Core Features**

Build audio recording system:

**Implementation:**
- Use AVAudioRecorder
- High-quality audio (44.1kHz)
- Handle interruptions (calls, etc.)
- Background recording support

**Output:**
- m4a format (compressed)
- Stored temporarily
- Automatic cleanup

**Acceptance Criteria:**
- [ ] Recording works reliably
- [ ] Audio quality is good
- [ ] Interruptions handled
- [ ] Memory managed" --label "phase-4,ios,voice"

gh issue create --title "Integrate Whisper API for real-time transcription" --body "**Phase 4: Core Features**

Connect iOS to Whisper:

**Flow:**
1. User speaks
2. Audio sent to backend
3. Transcription returned
4. Display in UI

**Features:**
- Streaming if possible
- Chunked for long recordings
- Error handling
- Retry logic

**Acceptance Criteria:**
- [ ] Transcription accurate
- [ ] Latency < 2 seconds
- [ ] Works in noisy environments
- [ ] Errors handled gracefully" --label "phase-4,ios,voice"

gh issue create --title "Build 5-question session flow logic" --body "**Phase 4: Core Features**

Implement session state machine:

**States:**
1. Starting (optional context)
2. Question 1-5 loop
3. Recap generation
4. Prince song recommendation
5. Complete

**Constraints:**
- Maximum 5 questions
- 1:1 exchange (one Q, one A)
- No AI suggestions during
- Auto-save progress

**Acceptance Criteria:**
- [ ] Flow is smooth
- [ ] 5-question limit enforced
- [ ] State persists if interrupted
- [ ] Completion tracked" --label "phase-4,ios,core"

gh issue create --title "Implement Claude API integration for questions" --body "**Phase 4: Core Features**

Connect iOS to question generation:

**Integration:**
- Call backend API
- Pass session context
- Receive next question
- Handle errors

**UX:**
- Loading state while generating
- Smooth question display
- Retry on failure

**Acceptance Criteria:**
- [ ] Questions generated contextually
- [ ] API calls efficient
- [ ] Errors handled
- [ ] Questions feel natural" --label "phase-4,ios,ai"

gh issue create --title "Create session recap generation" --body "**Phase 4: Core Features**

Build session summary:

**Content:**
- 2-3 sentence recap
- Key insights captured
- What was added to Canon

**Generation:**
- Use Claude to summarize
- Highlight main themes
- Show category updates

**Acceptance Criteria:**
- [ ] Recap is accurate
- [ ] Generated quickly
- [ ] Well-formatted
- [ ] Helpful to user" --label "phase-4,ios,ai"

gh issue create --title "Build Prince song recommendation UI" --body "**Phase 4: Core Features**

Display song recommendation:

**UI Components:**
- Song title (large)
- Album name
- Year
- 1-sentence reasoning
- 👍/👎 rating buttons
- \"Listen on Spotify\" link (if possible)

**Design:**
- Playful, fun
- Album art (if available)
- Easy to dismiss

**Acceptance Criteria:**
- [ ] Song displays beautifully
- [ ] Reasoning is clear
- [ ] Rating works
- [ ] Links to Spotify" --label "phase-4,ios,ui"

gh issue create --title "Implement Canon auto-categorization" --body "**Phase 4: Core Features**

Auto-organize Canon entries:

**Process:**
- After each session
- Categorize new entries
- Update existing categories
- Show what changed

**Categories:**
- Mission/Vision
- Product Principles
- Brand Voice
- Founding Story
- Non-negotiables
- Aesthetic Preferences
- Customer Philosophy
- Competitive Positioning

**Acceptance Criteria:**
- [ ] Categorization is accurate
- [ ] Updates are fast
- [ ] User can override
- [ ] History tracked" --label "phase-4,ios,ai"

gh issue create --title "Create Canon diff view (show updates)" --body "**Phase 4: Core Features**

Show what changed:

**Features:**
- Highlight new entries
- Show updated categories
- Compare versions
- \"What's new\" summary

**UI:**
- Clear visual indicators
- Easy to review
- Can view history

**Acceptance Criteria:**
- [ ] Diffs are clear
- [ ] Updates visible
- [ ] History accessible
- [ ] Performance good" --label "phase-4,ios,ui"

gh issue create --title "Build manual Canon editing with audit trail" --body "**Phase 4: Core Features**

Allow manual edits:

**Features:**
- Edit any entry
- Delete entries
- Add entries manually
- All changes logged

**Audit Trail:**
- Track who changed what
- When it was changed
- Original value
- \"Manually edited\" badge

**Acceptance Criteria:**
- [ ] Edits work correctly
- [ ] Changes are logged
- [ ] History is visible
- [ ] Can revert changes" --label "phase-4,ios,core"

gh issue create --title "Implement session completion tracking" --body "**Phase 4: Core Features**

Track user progress:

**Metrics:**
- Sessions started
- Sessions completed
- Questions answered
- Canon density score
- Streak tracking

**Display:**
- Progress indicators
- Achievement badges (optional)
- Stats screen

**Acceptance Criteria:**
- [ ] Tracking is accurate
- [ ] Stats display correctly
- [ ] Motivating to user
- [ ] Privacy-respecting" --label "phase-4,ios,analytics"

# Phase 5: Polish & Features
gh issue create --title "Add haptic feedback and animations" --body "**Phase 5: Polish & Features**

Enhance UX with polish:

**Haptics:**
- Button taps
- Recording start/stop
- Session complete
- Errors

**Animations:**
- Smooth transitions
- Loading states
- Celebratory moments
- Waveform animation

**Acceptance Criteria:**
- [ ] Haptics feel natural
- [ ] Animations smooth
- [ ] Performance maintained
- [ ] Accessibility respected" --label "phase-5,ios,polish"

gh issue create --title "Implement offline mode support" --body "**Phase 5: Polish & Features**

Handle no connectivity:

**Features:**
- Cache Canon locally
- Queue sessions for sync
- Offline indicator
- Auto-sync when online

**UX:**
- Clear offline state
- No data loss
- Graceful degradation

**Acceptance Criteria:**
- [ ] App works offline
- [ ] Data syncs when online
- [ ] No data loss
- [ ] User informed of state" --label "phase-5,ios,offline"

gh issue create --title "Create Canon export (PDF generation)" --body "**Phase 5: Polish & Features**

Build beautiful PDF export:

**Features:**
- Professional formatting
- Include all categories
- Add metadata (date, version)
- Branded design

**Implementation:**
- Use PDFKit
- Server-side or client-side
- Shareable via iOS share sheet

**Acceptance Criteria:**
- [ ] PDF looks professional
- [ ] All content included
- [ ] Easy to share
- [ ] Fast generation" --label "phase-5,ios,export"

gh issue create --title "Build analytics dashboard" --body "**Phase 5: Polish & Features**

Create user stats view:

**Metrics:**
- Total sessions
- Canon density score
- Categories completed
- Streak
- Prince song favorites

**Design:**
- Visual charts
- Encouraging copy
- Share-worthy stats

**Acceptance Criteria:**
- [ ] Dashboard is informative
- [ ] Data is accurate
- [ ] Visually appealing
- [ ] Motivating" --label "phase-5,ios,analytics"

gh issue create --title "Implement dead time reminder scheduling" --body "**Phase 5: Polish & Features**

Smart notification scheduling:

**Features:**
- ML-based timing (future)
- Manual time windows
- Frequency control
- Respect user preferences

**Logic:**
- Don't spam
- Learn best times
- Respect DND mode

**Acceptance Criteria:**
- [ ] Reminders are timely
- [ ] Not annoying
- [ ] Easy to configure
- [ ] Can disable" --label "phase-5,ios,notifications"

gh issue create --title "Add Prince song rating (👍/👎)" --body "**Phase 5: Polish & Features**

Track song feedback:

**Features:**
- Simple thumbs up/down
- Store preferences
- Influence future recommendations
- Track for drift detection

**Data:**
- Log all ratings
- Analyze patterns
- Detect drift

**Acceptance Criteria:**
- [ ] Rating is easy
- [ ] Preferences stored
- [ ] Influences recommendations
- [ ] Data collected for analysis" --label "phase-5,ios,ui"

gh issue create --title "Create drift detection metrics (internal)" --body "**Phase 5: Polish & Features**

Build canary monitoring:

**Metrics:**
- Prince song diversity
- Raspberry Beret frequency
- Question variety
- Canon uniqueness

**Dashboard (internal):**
- System-wide stats
- Drift alerts
- User-level analysis

**Acceptance Criteria:**
- [ ] Metrics collected
- [ ] Dashboard functional
- [ ] Alerts configured
- [ ] Actionable insights" --label "phase-5,backend,analytics"

gh issue create --title "Implement data encryption at rest" --body "**Phase 5: Polish & Features**

Secure user data:

**Implementation:**
- Encrypt database fields
- Encrypt audio files in S3
- Secure API keys
- HTTPS everywhere

**Compliance:**
- GDPR considerations
- Data retention policies
- User data deletion

**Acceptance Criteria:**
- [ ] Sensitive data encrypted
- [ ] Keys managed securely
- [ ] Compliance met
- [ ] Audit trail exists" --label "phase-5,backend,security"

gh issue create --title "Add user data deletion functionality" --body "**Phase 5: Polish & Features**

Implement account deletion:

**Features:**
- Full account deletion
- Delete all Canon data
- Delete all sessions
- Delete all audio files

**UX:**
- Confirmation required
- Export option first
- Permanent action warning

**Acceptance Criteria:**
- [ ] All data deleted
- [ ] No orphaned records
- [ ] Confirmation flow works
- [ ] Irreversible (with warning)" --label "phase-5,ios,privacy"

gh issue create --title "Build App Store assets and screenshots" --body "**Phase 5: Polish & Features**

Prepare for launch:

**Assets:**
- App icon (all sizes)
- Screenshots (all device sizes)
- Preview video
- App Store description
- Keywords

**Marketing:**
- Compelling copy
- Beautiful screenshots
- Clear value proposition

**Acceptance Criteria:**
- [ ] All assets created
- [ ] Screenshots polished
- [ ] Description compelling
- [ ] Ready for submission" --label "phase-5,marketing"

# Phase 6: Testing & Launch
gh issue create --title "Unit tests for critical backend services" --body "**Phase 6: Testing & Launch**

Implement backend testing:

**Test Coverage:**
- Auth endpoints
- Session management
- Question generation
- Canon structuring
- Transcription service

**Framework:**
- Jest or Mocha
- Minimum 70% coverage

**Acceptance Criteria:**
- [ ] Critical paths tested
- [ ] Tests pass consistently
- [ ] CI integration works
- [ ] Coverage meets target" --label "phase-6,testing,backend"

gh issue create --title "iOS UI tests for main flows" --body "**Phase 6: Testing & Launch**

Implement iOS testing:

**Test Coverage:**
- Onboarding flow
- Session recording
- Canon viewing
- Authentication

**Framework:**
- XCTest
- UI Testing

**Acceptance Criteria:**
- [ ] Main flows tested
- [ ] Tests run in CI
- [ ] Reliable execution
- [ ] No flaky tests" --label "phase-6,testing,ios"

gh issue create --title "Beta testing setup (TestFlight)" --body "**Phase 6: Testing & Launch**

Launch private beta:

**Setup:**
- TestFlight configuration
- Beta tester invites (50 founders)
- Feedback collection system
- Analytics tracking

**Process:**
- Weekly builds
- Bug tracking
- Feature feedback
- Iterate based on feedback

**Acceptance Criteria:**
- [ ] TestFlight live
- [ ] 50 beta testers invited
- [ ] Feedback system working
- [ ] Iteration process established" --label "phase-6,launch"

gh issue create --title "Performance optimization and bug fixes" --body "**Phase 6: Testing & Launch**

Polish for production:

**Performance:**
- API response times
- App launch time
- Memory usage
- Battery impact

**Bug Fixes:**
- Fix all critical bugs
- Address beta feedback
- Edge case handling

**Acceptance Criteria:**
- [ ] No critical bugs
- [ ] Performance targets met
- [ ] Beta feedback addressed
- [ ] Stable for launch" --label "phase-6,polish"

gh issue create --title "App Store submission preparation" --body "**Phase 6: Testing & Launch**

Final launch prep:

**Checklist:**
- [ ] App Store Connect setup
- [ ] Privacy policy published
- [ ] Terms of service
- [ ] Support email configured
- [ ] Pricing configured ($20/month)
- [ ] Release notes written
- [ ] Final build submitted

**Acceptance Criteria:**
- [ ] App submitted to App Store
- [ ] All metadata complete
- [ ] Legal docs in place
- [ ] Ready for review" --label "phase-6,launch"

echo "✅ All 55 issues created successfully!"
echo ""
echo "View issues at: https://github.com/fladry-creative/razberry_beret/issues"

