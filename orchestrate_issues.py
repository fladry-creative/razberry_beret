#!/usr/bin/env python3
"""
Razberry Beret - Issue Orchestra
Creating 55 perfectly labeled GitHub issues like Trent Reznor with a synth
"""

import subprocess
import json

issues = [
    # Phase 1: Foundation & Setup (2-11)
    {
        "title": "Initialize repository structure and documentation",
        "labels": ["phase-1", "setup"],
        "body": """**Phase 1: Foundation & Setup**

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
- [ ] Basic documentation in place"""
    },
    {
        "title": "Set up backend technology stack (Node.js/Express + Supabase)",
        "labels": ["phase-1", "backend", "setup"],
        "body": """**Phase 1: Foundation & Setup**

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
- [ ] /health endpoint responds"""
    },
    {
        "title": "Configure Anthropic API integration (Claude Sonnet 4.5)",
        "labels": ["phase-1", "backend", "ai"],
        "body": """**Phase 1: Foundation & Setup**

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
- [ ] Error handling implemented"""
    },
    {
        "title": "Set up OpenAI Whisper API for voice transcription",
        "labels": ["phase-1", "backend", "voice"],
        "body": """**Phase 1: Foundation & Setup**

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
- [ ] Error handling for failed transcriptions"""
    },
    {
        "title": "Design and implement database schema (users, sessions, canon)",
        "labels": ["phase-1", "backend", "database"],
        "body": """**Phase 1: Foundation & Setup**

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
- [ ] Seed data for prince_songs"""
    },
]

def create_issue(issue_data):
    """Create a single GitHub issue"""
    cmd = [
        "gh", "issue", "create",
        "--title", issue_data["title"],
        "--label", ",".join(issue_data["labels"]),
        "--body", issue_data["body"]
    ]
    
    result = subprocess.run(cmd, capture_output=True, text=True)
    if result.returncode == 0:
        issue_url = result.stdout.strip()
        issue_num = issue_url.split('/')[-1]
        print(f"✓ Created issue #{issue_num}: {issue_data['title'][:50]}...")
        return True
    else:
        print(f"✗ Failed: {issue_data['title'][:50]}...")
        print(f"  Error: {result.stderr}")
        return False

def main():
    print("🎹 Starting the GitHub Issue Symphony...")
    print(f"🎵 Creating {len(issues)} issues...\n")
    
    created = 0
    failed = 0
    
    for i, issue in enumerate(issues, 1):
        if create_issue(issue):
            created += 1
        else:
            failed += 1
    
    print(f"\n✅ Symphony complete!")
    print(f"   Created: {created} issues")
    print(f"   Failed: {failed} issues")
    print(f"\n🎸 View at: https://github.com/fladry-creative/razberry_beret/issues")

if __name__ == "__main__":
    main()

