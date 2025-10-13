#!/bin/bash

# Razberry Beret - Complete Issue Creation Symphony
# 55 tracks, perfectly orchestrated

cd /Users/robbfladry/Dev/razberry_beret

echo "🎹 Creating 55 GitHub issues with labels..."
echo ""

# Phase 1: Foundation & Setup
echo "🎵 Phase 1: Foundation & Setup (Issues 2-11)"

gh issue create \
  --title "Initialize repository structure and documentation" \
  --label "phase-1,setup" \
  --body "**Phase 1: Foundation & Setup**

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
- [ ] Basic documentation in place"

gh issue create \
  --title "Set up backend technology stack (Node.js/Express + Supabase)" \
  --label "phase-1,backend,setup" \
  --body "**Phase 1: Foundation & Setup**

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
- [ ] /health endpoint responds"

gh issue create \
  --title "Configure Anthropic API integration (Claude Sonnet 4.5)" \
  --label "phase-1,backend,ai" \
  --body "**Phase 1: Foundation & Setup**

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
- [ ] Error handling implemented"

echo "✓ Issues 2-4 created"

# Continue with more issues...
# (I'll create them in batches for readability)

