#!/bin/bash

# Razberry Beret - Label Symphony
# Adding labels to issues #2-56 like Trent Reznor layering synths

cd /Users/robbfladry/Dev/razberry_beret

echo "🎹 Adding labels to all 55 issues..."
echo ""

# Phase 1: Foundation & Setup (Issues 2-11)
echo "🎵 Phase 1: Foundation & Setup (#2-11)"
gh issue edit 2 --add-label "phase-1,setup"
gh issue edit 3 --add-label "phase-1,backend,setup"
gh issue edit 4 --add-label "phase-1,backend,ai"
gh issue edit 5 --add-label "phase-1,backend,voice"
gh issue edit 6 --add-label "phase-1,backend,database"
gh issue edit 7 --add-label "phase-1,backend,auth"
gh issue edit 8 --add-label "phase-1,ios,setup"
gh issue edit 9 --add-label "phase-1,setup,devops"
gh issue edit 10 --add-label "phase-1,devops"
gh issue edit 11 --add-label "phase-1,content"

# Phase 2: Backend API (Issues 12-21)
echo "🎵 Phase 2: Backend API (#12-21)"
gh issue edit 12 --add-label "phase-2,backend,auth"
gh issue edit 13 --add-label "phase-2,backend,core"
gh issue edit 14 --add-label "phase-2,backend,voice"
gh issue edit 15 --add-label "phase-2,backend,ai"
gh issue edit 16 --add-label "phase-2,backend,core"
gh issue edit 17 --add-label "phase-2,backend,ai"
gh issue edit 18 --add-label "phase-2,backend,ai"
gh issue edit 19 --add-label "phase-2,backend,analytics"
gh issue edit 20 --add-label "phase-2,backend,export"
gh issue edit 21 --add-label "phase-2,backend,core"

# Phase 3: iOS App - Core UI (Issues 22-31)
echo "🎵 Phase 3: iOS Core UI (#22-31)"
gh issue edit 22 --add-label "phase-3,ios,architecture"
gh issue edit 23 --add-label "phase-3,ios,ui"
gh issue edit 24 --add-label "phase-3,ios,ui"
gh issue edit 25 --add-label "phase-3,ios,ui,auth"
gh issue edit 26 --add-label "phase-3,ios,ui,voice"
gh issue edit 27 --add-label "phase-3,ios,ui,voice"
gh issue edit 28 --add-label "phase-3,ios,ui"
gh issue edit 29 --add-label "phase-3,ios,ui"
gh issue edit 30 --add-label "phase-3,ios,ui"
gh issue edit 31 --add-label "phase-3,ios,notifications"

# Phase 4: Core Features (Issues 32-41)
echo "🎵 Phase 4: Core Features (#32-41)"
gh issue edit 32 --add-label "phase-4,ios,voice"
gh issue edit 33 --add-label "phase-4,ios,voice"
gh issue edit 34 --add-label "phase-4,ios,core"
gh issue edit 35 --add-label "phase-4,ios,ai"
gh issue edit 36 --add-label "phase-4,ios,ai"
gh issue edit 37 --add-label "phase-4,ios,ui"
gh issue edit 38 --add-label "phase-4,ios,ai"
gh issue edit 39 --add-label "phase-4,ios,ui"
gh issue edit 40 --add-label "phase-4,ios,core"
gh issue edit 41 --add-label "phase-4,ios,analytics"

# Phase 5: Polish & Features (Issues 42-51)
echo "🎵 Phase 5: Polish & Features (#42-51)"
gh issue edit 42 --add-label "phase-5,ios,polish"
gh issue edit 43 --add-label "phase-5,ios,offline"
gh issue edit 44 --add-label "phase-5,ios,export"
gh issue edit 45 --add-label "phase-5,ios,analytics"
gh issue edit 46 --add-label "phase-5,ios,notifications"
gh issue edit 47 --add-label "phase-5,ios,ui"
gh issue edit 48 --add-label "phase-5,backend,analytics"
gh issue edit 49 --add-label "phase-5,backend,security"
gh issue edit 50 --add-label "phase-5,ios,privacy"
gh issue edit 51 --add-label "phase-5,marketing"

# Phase 6: Testing & Launch (Issues 52-56)
echo "🎵 Phase 6: Testing & Launch (#52-56)"
gh issue edit 52 --add-label "phase-6,testing,backend"
gh issue edit 53 --add-label "phase-6,testing,ios"
gh issue edit 54 --add-label "phase-6,launch"
gh issue edit 55 --add-label "phase-6,polish"
gh issue edit 56 --add-label "phase-6,launch"

echo ""
echo "✅ All 55 issues labeled!"
echo "🎸 https://github.com/fladry-creative/razberry_beret/issues"
echo "🏷️  Filter by phase: phase-1, phase-2, phase-3, phase-4, phase-5, phase-6"
echo "🏷️  Filter by tech: backend, ios, ai, voice, ui, core"
echo ""
echo "🎹 The symphony is ready. Time to play."

