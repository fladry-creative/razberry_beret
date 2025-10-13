# Database Setup

This directory contains the database schema and migrations for Razberry Beret.

## Structure

```
database/
├── migrations/
│   └── 001_initial_schema.sql    # Main schema with all tables
├── seeds/
│   └── prince_songs.sql           # Prince song catalog (50+ deep cuts)
└── README.md                       # This file
```

## Schema Overview

### Core Tables

#### `users`
Stores user accounts with subscription tiers.
- **Key fields:** email, subscription_tier (free/pro), total_sessions
- **RLS:** Users can only access their own data

#### `sessions`
Voice capture sessions with 5-question limit.
- **Key fields:** user_id, status, question_count, prince_song_id, recap
- **Status:** in_progress, completed, abandoned
- **RLS:** Users can only access their own sessions

#### `session_exchanges`
Individual question/answer pairs within sessions.
- **Key fields:** session_id, question_number (1-5), question, user_response
- **Unique constraint:** One exchange per question number per session
- **RLS:** Accessible only through user's sessions

#### `canon_entries`
Structured brand insights extracted from sessions.
- **Key fields:** user_id, category, content, source_session_id
- **Categories:** mission, vision, voice, principles, values, positioning, etc.
- **Features:** Full-text search, audit trail, manual edit tracking
- **RLS:** Users can only access their own canon

#### `prince_songs`
Database of Prince songs for recommendations.
- **Key fields:** title, album, year, is_deep_cut, mood_tags
- **Features:** Mood-based filtering, deep cut detection
- **RLS:** Readable by all authenticated users

#### `song_recommendations`
Prince song recommendations per session.
- **Key fields:** session_id, song_id, reasoning, user_rating
- **Rating:** 1 (thumbs down) or 2 (thumbs up)
- **RLS:** Accessible only through user's sessions

#### `analytics_events`
User activity tracking and metrics.
- **Key fields:** user_id, event_type, event_data (JSONB)
- **Features:** Time-series queries, JSONB filtering
- **RLS:** Users can only access their own events

## Applying Migrations

### Option 1: Supabase Dashboard (Recommended)

1. Go to your Supabase project dashboard
2. Navigate to **SQL Editor**
3. Copy contents of `migrations/001_initial_schema.sql`
4. Execute the migration
5. Copy contents of `seeds/prince_songs.sql`
6. Execute the seed data

### Option 2: Supabase CLI

```bash
# Install Supabase CLI if needed
npm install -g supabase

# Link to your project
supabase link --project-ref your-project-ref

# Apply migration
supabase db push

# Or run SQL directly
supabase db execute --file migrations/001_initial_schema.sql
supabase db execute --file seeds/prince_songs.sql
```

### Option 3: psql (Local Development)

```bash
# Connect to your database
psql postgresql://user:pass@host:port/database

# Apply migration
\i migrations/001_initial_schema.sql

# Apply seed data
\i seeds/prince_songs.sql
```

## Row Level Security (RLS)

All tables have RLS enabled to ensure data isolation:

- **Users:** Can only access their own record
- **Sessions:** Can only access sessions they created
- **Session Exchanges:** Can only access through their sessions
- **Canon Entries:** Can only access their own canon
- **Song Recommendations:** Can only access through their sessions
- **Analytics Events:** Can only access their own events
- **Prince Songs:** Readable by all authenticated users

## Indexes

Optimized for common query patterns:

- **User lookups:** email, subscription tier
- **Session queries:** user_id + status, chronological
- **Canon search:** user_id + category, full-text search
- **Analytics:** user_id + event_type, time-series
- **Prince songs:** deep_cut flag, mood tags (GIN)

## Triggers

### Auto-update timestamps
- `users.updated_at` - Updated on every modification
- `canon_entries.updated_at` - Updated on every modification

### Business logic
- `sessions` → `users.total_sessions` - Auto-increments when session completes

## Constraints

### Data Validation
- **Subscription tiers:** Only 'free' or 'pro'
- **Session status:** Only 'in_progress', 'completed', or 'abandoned'
- **Question count:** Between 0 and 5
- **Question number:** Between 1 and 5
- **Transcription confidence:** Between 0.0 and 1.0
- **Song year:** Between 1978 and 2016 (Prince's career)
- **User rating:** Only 1 (thumbs down) or 2 (thumbs up)
- **Canon categories:** Predefined set of 13 categories

### Foreign Keys
All foreign keys use `ON DELETE CASCADE` or `ON DELETE SET NULL`:
- **CASCADE:** Child records deleted when parent deleted
  - sessions → users
  - session_exchanges → sessions
  - canon_entries → users
  - song_recommendations → sessions, prince_songs
  - analytics_events → users

- **SET NULL:** Reference cleared but record preserved
  - sessions → prince_songs
  - canon_entries → sessions, session_exchanges

## Querying Examples

### Get user's complete canon
```sql
SELECT category, content, created_at
FROM canon_entries
WHERE user_id = 'user-uuid'
ORDER BY category, created_at DESC;
```

### Search canon by keyword
```sql
SELECT content, category
FROM canon_entries
WHERE user_id = 'user-uuid'
  AND to_tsvector('english', content) @@ plainto_tsquery('english', 'authentic voice');
```

### Get user's session history
```sql
SELECT 
  s.id,
  s.created_at,
  s.question_count,
  ps.title as recommended_song,
  s.recap
FROM sessions s
LEFT JOIN prince_songs ps ON s.prince_song_id = ps.id
WHERE s.user_id = 'user-uuid'
  AND s.status = 'completed'
ORDER BY s.created_at DESC
LIMIT 10;
```

### Analyze song recommendation diversity
```sql
SELECT 
  ps.title,
  COUNT(*) as recommendation_count,
  AVG(CASE WHEN sr.user_rating = 2 THEN 1.0 ELSE 0.0 END) as approval_rate
FROM song_recommendations sr
JOIN prince_songs ps ON sr.song_id = ps.id
GROUP BY ps.id, ps.title
ORDER BY recommendation_count DESC;
```

### Drift detection: Check for "Raspberry Beret"
```sql
-- This should ideally return 0 or very low percentage
SELECT 
  COUNT(*) FILTER (WHERE ps.title ILIKE '%raspberry%') as raspberry_count,
  COUNT(*) as total_recommendations,
  ROUND(100.0 * COUNT(*) FILTER (WHERE ps.title ILIKE '%raspberry%') / COUNT(*), 2) as consensus_drift_percent
FROM song_recommendations sr
JOIN prince_songs ps ON sr.song_id = ps.id;
```

## Maintenance

### Update statistics
```sql
ANALYZE users;
ANALYZE sessions;
ANALYZE canon_entries;
ANALYZE prince_songs;
ANALYZE song_recommendations;
```

### Check table sizes
```sql
SELECT 
  schemaname,
  tablename,
  pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) AS size
FROM pg_tables
WHERE schemaname = 'public'
ORDER BY pg_total_relation_size(schemaname||'.'||tablename) DESC;
```

### Vacuum and analyze
```sql
VACUUM ANALYZE;
```

## Backup

### Supabase
Automatic backups are handled by Supabase. Configure backup retention in your project settings.

### Manual Backup
```bash
# Dump schema and data
pg_dump -h your-host -U postgres -d postgres > backup.sql

# Dump only schema
pg_dump -h your-host -U postgres -d postgres --schema-only > schema.sql

# Dump only data
pg_dump -h your-host -U postgres -d postgres --data-only > data.sql
```

## Migration Strategy

Future migrations should:
1. Be numbered sequentially: `002_*.sql`, `003_*.sql`, etc.
2. Be idempotent when possible (use `IF NOT EXISTS`)
3. Include both UP and DOWN migrations
4. Be tested on a staging environment first
5. Document any breaking changes

## Notes

- **Prince Songs:** The catalog intentionally avoids mainstream hits to detect AI drift
- **Deep Cuts:** 80%+ of songs should be marked as `is_deep_cut = true`
- **Mood Tags:** Array field allows flexible categorization
- **Canon Audit Trail:** JSONB array tracks all manual edits
- **Session Limit:** Hard limit of 5 questions per session (enforced at DB level)

