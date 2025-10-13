# **PRD: Razberry Beret**
## *The Corpus Defense System for Founders*

**Version:** 0.1  
**Date:** October 13, 2025  
**Status:** Pre-Build / Founding Document  
**Author:** [Your Name]

---

## **1. VISION & PROBLEM**

### **The Problem:**
Every founder using AI in 2025 is unknowingly building a company that's 60% their truth and 40% statistical consensus. AI tools trained on 10 trillion tokens pull entrepreneurs toward "what companies like yours usually do" - turning unique visions into generic, averaged-out versions of themselves.

**This is AI drift.** And by the time you notice it, your brand voice, your product positioning, and your company identity have already been homogenized.

### **The Solution:**
**Razberry Beret** is a voice-first iPhone app that captures your canonical truth *before* AI can dilute it. Through constrained, conversational exchanges during dead time (waiting for Ubers, sitting in dentist offices), founders build an immutable brand bible that serves as the primary source for all future AI interactions.

### **The Name:**
"Razberry Beret" - intentionally misspelled. A signal that:
- We're not the consensus choice
- We embrace human imperfection over AI perfection  
- The misspelling itself is a canary (if AI ever "corrects" it, we know drift is happening)
- It's memorable, searchable, and impossible to confuse with anything else

**Tagline:** *"Don't let AI turn you into a statistically average founder."*

---

## **2. USER PERSONA**

### **Primary: The Technical Founder (Pre-Seed to Series A)**

**Profile:**
- Age: 25-40
- Building a tech startup (SaaS, AI, consumer app)
- Uses AI daily (ChatGPT, Claude, Cursor, etc.)
- iPhone user, AirPods always in
- Reads Paul Graham essays, follows tech Twitter
- Time-poor, context-rich
- Worried about "sounding like everyone else"

**Pain Points:**
- Every marketing copy they write sounds the same
- Can't tell anymore what's "them" vs "what AI suggested"
- Team members using AI are creating brand inconsistency
- No single source of truth for "who we actually are"
- Traditional brand guidelines feel sterile and don't capture voice/vision

**Behaviors:**
- Has 10-30 minutes of dead time per day (commuting, waiting, walking)
- Already talks to themselves/thinks out loud
- Willing to look weird using voice tech in public
- Values efficiency but craves authenticity

---

## **3. CORE FEATURES (V1 - MVP)**

### **3.1 Voice Capture Sessions**

**Trigger:** User opens app (or scheduled prompt during configured "dead time" windows)

**Flow:**
1. User speaks freely for 15-30 seconds (optional context-setting)
2. App responds with **one question** (powered by Claude Sonnet 4.5)
3. User answers (voice)
4. App responds with **one question**
5. Repeat for maximum **5 questions total**
6. Session ends with:
   - Brief recap (2-3 sentences summarizing what was captured)
   - Prince song recommendation (with 1-sentence reasoning)

**Critical Constraints:**
- **1:1 exchange only** (one question, one answer - no paragraphs of AI response)
- **5 question hard limit** (prevents drift, keeps sessions tight)
- **Voice-only input** (no typing - captures authentic voice)
- **No AI "suggestions"** during capture (prevents corpus contamination)

### **3.2 The Canon (Brand Bible)**

**What It Stores:**
- Raw transcripts of all sessions
- Structured extraction of:
  - Company mission/vision statements
  - Product principles ("We believe...")
  - Brand voice characteristics  
  - Founding story/origin
  - Non-negotiables ("We will never...")
  - Aesthetic preferences
  - Customer philosophy
  - Competitive positioning

**Presentation:**
- Single, clean, scrollable document
- Organized by category (auto-tagged by AI)
- Searchable
- Shows "last updated" dates for each section
- Can export as PDF or markdown

**Key Principle:** Canon is append-only during sessions. Edits can only happen through new voice sessions or manual override (with audit trail).

### **3.3 The Prince Song Canary**

**Purpose:** Quality control mechanism to detect AI drift

**How It Works:**
- At the end of every session, app recommends a Prince song
- Song choice is influenced by:
  - Tone/emotion of the conversation
  - Topics discussed
  - User's energy level
  - Claude's "creative freedom" (NOT optimizing for consensus)

**What We're Watching:**
- If recommendations start clustering around "Raspberry Beret," "Purple Rain," etc. = system is drifting toward safe consensus
- If recommendations stay varied (deep cuts, unexpected choices) = system is maintaining creativity

**User-Facing:**
- Presented as "delightful randomness"
- No explanation of the canary function to users (it's our internal quality metric)
- Users can rate songs (👍/👎) to help us track drift

### **3.4 Question Generation Logic**

**Claude's Job:**
The AI analyzes:
1. Existing canon (what's already captured)
2. Current session context
3. Gaps in the brand bible
4. User's speaking patterns/energy

**Question Types:**
- **Foundational:** "Why did you start this company?"
- **Principle-based:** "What's a common industry practice you refuse to adopt?"
- **Specific:** "How do you want customers to feel after using your product?"
- **Contrarian:** "What do your competitors get wrong?"
- **Personal:** "What personal experience shaped this vision?"
- **Edge cases:** "What would make you shut down the company?"

**Quality Bar:**
- Questions must be open-ended
- Must drive toward capturing *truth*, not validating existing assumptions
- Should feel conversational, not corporate
- Avoid leading questions

---

## **4. USER FLOWS**

### **4.1 First-Time User Onboarding**

1. **Download & Sign Up**
   - Email/phone login
   - Brief explainer (30 seconds): "Build your brand's source code"
   
2. **First Session Setup**
   - "We're going to ask you 5 questions about your company. Just speak naturally."
   - Permission requests: Microphone access
   
3. **The First Five**
   - Q1: "Tell me about your company. What are you building?" (warm-up)
   - Q2-5: Adaptive based on Q1 answer
   
4. **First Canon View**
   - "Here's what we captured. This is the beginning of your canon."
   - Show structured output
   - First Prince song

5. **Set Up Dead Time Reminders** (Optional)
   - "When do you usually have 5 minutes to think?"
   - Configure time windows (e.g., "Weekdays 8-9am, 5-6pm")

### **4.2 Returning User - Regular Session**

1. Open app (or respond to notification)
2. Quick context (optional): "What's on your mind?"
3. Five-question exchange
4. Recap + Prince song
5. "Your canon has been updated" (with diff view option)

### **4.3 Reviewing/Editing Canon**

1. Tap "View Canon" from home screen
2. See organized, categorized content
3. Can browse by:
   - Category (Mission, Voice, Principles, etc.)
   - Date captured
   - Search
4. Manual edits allowed but marked as "manually edited on [date]"

---

## **5. TECHNICAL ARCHITECTURE**

### **5.1 Platform**
- **iOS only** (iPhone) - V1
- Native Swift app
- Minimum iOS 17+

### **5.2 AI Infrastructure**
- **Primary LLM:** Claude Sonnet 4.5 (via Anthropic API)
- **Voice-to-Text:** Whisper API (OpenAI) or native iOS speech recognition
- **Text-to-Speech:** ElevenLabs or native iOS (for question playback - optional feature)

### **5.3 Data Storage**
- User authentication: Supabase or Firebase Auth
- Canon storage: Postgres database (per-user encrypted)
- Audio files: S3 bucket (optional retention for user playback)
- Session metadata: Timestamps, question/answer pairs, tags

### **5.4 Key Technical Decisions**

**Real-time vs Batch Processing:**
- Voice transcription: Real-time (near-instant)
- Question generation: Real-time (sub-2 second response)
- Canon structuring: Batch (every 24 hours, reorganize/tag content)

**Privacy/Security:**
- All data encrypted at rest and in transit
- User can delete entire canon at any time
- No sharing/social features in V1 (this is private founder work)
- Optional: Local-only mode (canon stored on device, not cloud)

---

## **6. SUCCESS METRICS**

### **North Star Metric:**
**Canon Density Score** = (# of structured insights captured) / (# of sessions completed)

Target: 8-12 insights per session on average

### **Engagement Metrics:**
- **Retention:**
  - D1, D7, D30 retention rates
  - Target: 70% D7, 40% D30
- **Session frequency:**
  - Target: 3+ sessions per week
- **Session completion:**
  - % of sessions that reach 5 questions
  - Target: 85%+

### **Quality Metrics:**
- **Canon coverage:**
  - % of key categories filled (Mission, Voice, Principles, etc.)
  - Target: 80% coverage within 30 days
- **Prince song diversity:**
  - # of unique songs recommended per user
  - If this drops below 50% unique = drift alert
- **User-reported value:**
  - Post-session survey: "Did this feel valuable?" (👍/👎)
  - Target: 80%+ positive

### **The Canary Metric** (Internal Only):
- **Consensus Drift Score:**
  - Track how often we recommend "Raspberry Beret" vs deep cuts
  - If "Raspberry Beret" appears in >10% of sessions = investigate
  - This is our early warning system

---

## **7. GO-TO-MARKET STRATEGY**

### **Phase 1: Private Beta (Months 1-2)**
- 50 hand-selected founders (YC network, tech Twitter)
- Goal: Validate core loop, iterate on question quality
- Metric: 3+ sessions per user in first week

### **Phase 2: Invite-Only Launch (Months 3-4)**
- Each beta user gets 5 invite codes
- Viral mechanics: "Your canon is private, but your tool doesn't have to be"
- Target: 500 total users

### **Phase 3: Public Launch (Month 5+)**
- Product Hunt launch
- Tech Twitter campaign: "The Raspberry Beret Problem"
- Blog post: "Why Every Founder Using AI is Becoming Generic (And How to Stop It)"
- Pricing intro: Free for first 100 sessions, then $20/month

### **Marketing Positioning:**

**What we're NOT:**
- A productivity tool
- A voice note app  
- A brand guidelines generator

**What we ARE:**
- An identity preservation system
- A corpus defense mechanism
- The vaccine against AI-induced mediocrity

**Key Messages:**
- "Build your brand's source code"
- "Stay yourself while scaling with AI"
- "The anti-Raspberry Beret"

---

## **8. MONETIZATION**

### **V1 Pricing:**
**Freemium Model:**
- **Free Tier:**
  - 100 total sessions (lifetime)
  - Full canon access
  - Export as PDF
  
- **Pro Tier ($20/month or $200/year):**
  - Unlimited sessions
  - Priority question generation (Claude with extended thinking)
  - "Drift Detection" feature (coming in V2 - analyzes your AI outputs against canon)
  - Team sharing (up to 5 co-founders)
  - API access to canon (for feeding into other AI tools)

### **Future Revenue Streams:**
- **Enterprise tier:** Company-wide canon for consistency across teams
- **Canon API:** Pay-per-query for developers building AI tools
- **"Anti-Drift Audit":** One-time service analyzing a founder's existing content against their canon

---

## **9. ROADMAP**

### **V1: MVP (Months 1-3)**
✅ Voice capture sessions (5 questions, 1:1 format)  
✅ Canon building & viewing  
✅ Prince song recommendations  
✅ iPhone app (iOS only)  
✅ Basic analytics dashboard

### **V2: Intelligence Layer (Months 4-6)**
- **Drift Detection:** Upload any text (email, pitch deck, marketing copy) and get scored against your canon
- **Canon Diff View:** See how your answers evolve over time
- **Smart Reminders:** ML-powered suggestions for when to capture (based on usage patterns)
- **Voice Export:** Hear your own voice reading sections of your canon

### **V3: Collaboration (Months 7-9)**
- **Team Canon:** Co-founders can contribute, with version control
- **Canon Conflicts:** Flag when team members have contradictory answers
- **Investor Mode:** Sanitized canon view for sharing with investors/advisors

### **V4: Integration (Months 10-12)**
- **Canon API:** REST API for developers to query the canon
- **ChatGPT Plugin:** "Ask my canon" functionality
- **Browser Extension:** Real-time canon checking while using AI tools
- **Notion/Confluence Sync:** Auto-update company wikis from canon

---

## **10. OPEN QUESTIONS & RISKS**

### **Open Questions:**

1. **Prince Estate/Licensing:**
   - Do we need permission to recommend songs?
   - Is there a fair use argument since we're not playing/hosting music?
   - Alternative: Partner with Spotify for direct links?

2. **Voice Privacy:**
   - Should we store raw audio or just transcripts?
   - What if users want to delete sessions but keep insights?

3. **Question Exhaustion:**
   - Will we run out of good questions after 100 sessions?
   - How do we keep it fresh for power users?

4. **The "Raspberry Beret" Problem:**
   - What if Claude Sonnet 4.5 is ALREADY trained to pick "Raspberry Beret"?
   - How do we calibrate the canary from day one?

5. **B2B vs B2C:**
   - Should we allow team plans from the start?
   - Or stay ruthlessly focused on solo founders?

### **Key Risks:**

**Technical:**
- Voice recognition accuracy in noisy environments (Uber, coffee shop)
- API costs for Claude Sonnet 4.5 at scale
- App Store review process for voice recording apps

**Product:**
- Users might find 5-question limit frustrating (or too short)
- Canon might feel "incomplete" for weeks, reducing retention
- Prince song might feel gimmicky to some users

**Market:**
- Founders might not feel the AI drift problem yet (too early?)
- Voice-first might be a barrier (some prefer typing)
- iPhone-only limits addressable market

**Competitive:**
- Big players (Notion, Google) could easily add this feature
- Voice AI space is crowded - differentiation is hard

**Mitigation:**
- Start small, iterate fast
- Build in public with founder community
- Focus on the "why" (corpus defense) not just the "what" (voice app)

---

## **11. WHY NOW?**

**Technology:**
- Claude Sonnet 4.5 is finally good enough for natural conversation
- Voice recognition is at human-level accuracy
- AirPods are ubiquitous = voice UX is normalized

**Market:**
- Founders are 18 months into AI boom = starting to notice drift
- "AI authenticity" is becoming a founder anxiety (Twitter discourse)
- No existing solution addresses this specific problem

**Cultural:**
- Post-MJ internet has trained AI on consensus, not creativity
- Raspberry Beret Problem is real but unnamed
- Founders are ready for tools that make them MORE themselves, not more efficient

**Timing:**
October 2025 = perfect moment to launch before "corpus defense" becomes a category.

---

## **12. THE BATDANCE TEST**

**How We'll Know We've Succeeded:**

If, after 10,000 sessions across 1,000 users:
- The Prince song recommendations remain diverse (50%+ unique songs)
- User canons feel authentically different from each other
- Founders report using their canon to "stay on brand" when using AI
- We see ZERO instances of "Raspberry Beret" for 30 days straight

**Then we'll know:** We built a corpus defense system that actually works.

---

## **13. FIRST STEPS**

### **Week 1:**
1. Register "Razberry Beret" domain + social handles
2. Set up Anthropic API account (Claude Sonnet 4.5)
3. Build rapid prototype:
   - Simple voice input → Claude → structured output
   - Test question generation quality
   - Validate 1:1 constraint feels natural

### **Week 2:**
4. iOS app shell (native Swift)
5. Integrate voice recognition
6. Build basic Canon view
7. Add Prince song randomizer (hardcoded list of 50 songs)

### **Week 3:**
8. Alpha test with 5 founders
9. Iterate on question quality
10. Refine Canon categorization
11. Validate "dead time" use case

### **Week 4:**
12. Private beta launch (50 invites)
13. Set up analytics
14. Monitor Canary metric
15. Start building waitlist

---

## **APPENDIX A: Sample Session**

**User:** [Opens app while waiting for Uber]

**App:** "What's on your mind today?"

**User:** "Just thinking about pricing. I have no idea how to price this thing."

**App (Q1):** "What does your customer lose if they don't have your product?"

**User:** "Time, mostly. And probably money because they're using duct-tape solutions that break."

**App (Q2):** "If time is the core value, should your pricing reflect how much time you save them, or something else?"

**User:** "Hmm. I mean, maybe? But that feels like it could get expensive fast. I want this to be accessible."

**App (Q3):** "What does 'accessible' mean to you - who specifically should be able to afford this?"

**User:** "Solo founders and small teams. Not just VCs-backed startups. People bootstrapping."

**App (Q4):** "Would you rather price low and risk being perceived as cheap, or price fairly and exclude some people at first?"

**User:** "Definitely price fairly. I'd rather be exclusive at first than be seen as a budget option."

**App (Q5):** "Got it. Last one: what would make you angry if a competitor charged for it?"

**User:** "Basic features. Like, if you charge extra for the core thing the product does, that's bullshit."

**App:** "Here's what I captured: You believe pricing should reflect value (time savings), stay accessible to bootstrapped founders, and never gate core features. Your pricing philosophy is about being fair, not cheap.

*Your Prince song: 'Alphabet St.' - playful, confident, and doesn't take itself too seriously.*"

**[Uber arrives. Session complete. Canon updated.]**

---

## **APPENDIX B: The Misspelling Strategy**

**Why "Razberry" (not "Raspberry"):**

1. **Searchable:** No confusion with the fruit, the Pi computer, or the Prince song itself
2. **Memorable:** Misspelling is a pattern interrupt
3. **Brandable:** We can own "Razberry" completely
4. **Meta:** The misspelling *is the point* - we're not trying to be the statistically correct answer
5. **Social:** Creates natural conversation ("Wait, is that spelled wrong?" "Yeah, that's the point.")

**Marketing Plays:**
- "Razberry > Raspberry" (we're better than the consensus choice)
- "Can't spell it? You get it." (the misspelling is a feature)
- "Auto-correct this." (playing with AI trying to "fix" us)

---

## **LET'S BUILD THIS.**

**Next move:** You pick the first 10 founders for private alpha, I'll build the prototype.

Sound good?
