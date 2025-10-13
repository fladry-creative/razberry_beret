-- Razberry Beret Database Schema
-- Migration 001: Initial schema
-- Created: 2025-10-13

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================
-- USERS TABLE
-- ============================================
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  email TEXT UNIQUE NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  subscription_tier TEXT NOT NULL DEFAULT 'free',
  total_sessions INTEGER NOT NULL DEFAULT 0,
  settings JSONB DEFAULT '{}',
  CONSTRAINT valid_subscription_tier CHECK (subscription_tier IN ('free', 'pro'))
);

-- Index for email lookups
CREATE INDEX idx_users_email ON users(email);

-- Index for subscription tier
CREATE INDEX idx_users_subscription ON users(subscription_tier);

-- ============================================
-- PRINCE SONGS TABLE
-- ============================================
CREATE TABLE prince_songs (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  title TEXT NOT NULL,
  album TEXT,
  year INTEGER,
  is_deep_cut BOOLEAN DEFAULT TRUE,
  spotify_url TEXT,
  apple_music_url TEXT,
  reasoning_template TEXT,
  mood_tags TEXT[] DEFAULT '{}',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CONSTRAINT valid_year CHECK (year >= 1978 AND year <= 2016)
);

-- Index for deep cut filtering
CREATE INDEX idx_prince_songs_deep_cut ON prince_songs(is_deep_cut);

-- Index for mood tags (GIN for array operations)
CREATE INDEX idx_prince_songs_mood_tags ON prince_songs USING GIN(mood_tags);

-- ============================================
-- SESSIONS TABLE
-- ============================================
CREATE TABLE sessions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  completed_at TIMESTAMPTZ,
  status TEXT NOT NULL DEFAULT 'in_progress',
  question_count INTEGER NOT NULL DEFAULT 0,
  prince_song_id UUID REFERENCES prince_songs(id) ON DELETE SET NULL,
  recap TEXT,
  metadata JSONB DEFAULT '{}',
  CONSTRAINT valid_status CHECK (status IN ('in_progress', 'completed', 'abandoned')),
  CONSTRAINT valid_question_count CHECK (question_count >= 0 AND question_count <= 5)
);

-- Index for user lookups
CREATE INDEX idx_sessions_user_id ON sessions(user_id);

-- Index for status filtering
CREATE INDEX idx_sessions_status ON sessions(status);

-- Index for created_at (for chronological queries)
CREATE INDEX idx_sessions_created_at ON sessions(created_at DESC);

-- Composite index for user + status queries
CREATE INDEX idx_sessions_user_status ON sessions(user_id, status);

-- ============================================
-- SESSION EXCHANGES TABLE
-- ============================================
CREATE TABLE session_exchanges (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  session_id UUID NOT NULL REFERENCES sessions(id) ON DELETE CASCADE,
  question_number INTEGER NOT NULL,
  question TEXT NOT NULL,
  user_response TEXT NOT NULL,
  transcription_confidence FLOAT,
  audio_file_url TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CONSTRAINT valid_question_number CHECK (question_number >= 1 AND question_number <= 5),
  CONSTRAINT valid_confidence CHECK (transcription_confidence IS NULL OR (transcription_confidence >= 0 AND transcription_confidence <= 1))
);

-- Index for session lookups
CREATE INDEX idx_exchanges_session_id ON session_exchanges(session_id);

-- Composite index for session + question number (unique constraint)
CREATE UNIQUE INDEX idx_exchanges_session_question ON session_exchanges(session_id, question_number);

-- ============================================
-- CANON ENTRIES TABLE
-- ============================================
CREATE TABLE canon_entries (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  category TEXT NOT NULL,
  content TEXT NOT NULL,
  source_session_id UUID REFERENCES sessions(id) ON DELETE SET NULL,
  source_exchange_id UUID REFERENCES session_exchanges(id) ON DELETE SET NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  manually_edited BOOLEAN DEFAULT FALSE,
  audit_trail JSONB DEFAULT '[]',
  CONSTRAINT valid_category CHECK (category IN (
    'mission',
    'vision',
    'voice',
    'principles',
    'values',
    'positioning',
    'customer_philosophy',
    'product_principles',
    'founding_story',
    'non_negotiables',
    'aesthetic',
    'competitive_stance',
    'other'
  ))
);

-- Index for user lookups
CREATE INDEX idx_canon_user_id ON canon_entries(user_id);

-- Index for category filtering
CREATE INDEX idx_canon_category ON canon_entries(category);

-- Composite index for user + category queries
CREATE INDEX idx_canon_user_category ON canon_entries(user_id, category);

-- Full-text search index on content
CREATE INDEX idx_canon_content_search ON canon_entries USING GIN(to_tsvector('english', content));

-- Index for source session lookups
CREATE INDEX idx_canon_source_session ON canon_entries(source_session_id);

-- ============================================
-- SONG RECOMMENDATIONS TABLE
-- ============================================
CREATE TABLE song_recommendations (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  session_id UUID NOT NULL REFERENCES sessions(id) ON DELETE CASCADE,
  song_id UUID NOT NULL REFERENCES prince_songs(id) ON DELETE CASCADE,
  reasoning TEXT NOT NULL,
  user_rating INTEGER,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CONSTRAINT valid_rating CHECK (user_rating IS NULL OR user_rating IN (1, 2))
);

-- Index for session lookups
CREATE INDEX idx_recommendations_session_id ON song_recommendations(session_id);

-- Index for song lookups
CREATE INDEX idx_recommendations_song_id ON song_recommendations(song_id);

-- Index for rating analysis
CREATE INDEX idx_recommendations_rating ON song_recommendations(user_rating) WHERE user_rating IS NOT NULL;

-- ============================================
-- ANALYTICS EVENTS TABLE
-- ============================================
CREATE TABLE analytics_events (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  event_type TEXT NOT NULL,
  event_data JSONB DEFAULT '{}',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Index for user lookups
CREATE INDEX idx_analytics_user_id ON analytics_events(user_id);

-- Index for event type filtering
CREATE INDEX idx_analytics_event_type ON analytics_events(event_type);

-- Index for time-based queries
CREATE INDEX idx_analytics_created_at ON analytics_events(created_at DESC);

-- Composite index for user + event type queries
CREATE INDEX idx_analytics_user_event_type ON analytics_events(user_id, event_type);

-- GIN index for JSONB queries
CREATE INDEX idx_analytics_event_data ON analytics_events USING GIN(event_data);

-- ============================================
-- FUNCTIONS & TRIGGERS
-- ============================================

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger for users table
CREATE TRIGGER update_users_updated_at
  BEFORE UPDATE ON users
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- Trigger for canon_entries table
CREATE TRIGGER update_canon_updated_at
  BEFORE UPDATE ON canon_entries
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- Function to increment user's total_sessions
CREATE OR REPLACE FUNCTION increment_user_sessions()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.status = 'completed' AND (OLD.status IS NULL OR OLD.status != 'completed') THEN
    UPDATE users SET total_sessions = total_sessions + 1 WHERE id = NEW.user_id;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger to auto-increment total_sessions when session completes
CREATE TRIGGER update_user_sessions_on_completion
  AFTER UPDATE ON sessions
  FOR EACH ROW
  EXECUTE FUNCTION increment_user_sessions();

-- ============================================
-- ROW LEVEL SECURITY (RLS)
-- ============================================

-- Enable RLS on all tables
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE session_exchanges ENABLE ROW LEVEL SECURITY;
ALTER TABLE canon_entries ENABLE ROW LEVEL SECURITY;
ALTER TABLE song_recommendations ENABLE ROW LEVEL SECURITY;
ALTER TABLE analytics_events ENABLE ROW LEVEL SECURITY;

-- Users can only see their own data
CREATE POLICY users_own_data ON users
  FOR ALL
  USING (auth.uid() = id);

-- Users can only see their own sessions
CREATE POLICY users_own_sessions ON sessions
  FOR ALL
  USING (user_id = auth.uid());

-- Users can only see exchanges from their sessions
CREATE POLICY users_own_exchanges ON session_exchanges
  FOR ALL
  USING (session_id IN (SELECT id FROM sessions WHERE user_id = auth.uid()));

-- Users can only see their own canon
CREATE POLICY users_own_canon ON canon_entries
  FOR ALL
  USING (user_id = auth.uid());

-- Users can only see recommendations from their sessions
CREATE POLICY users_own_recommendations ON song_recommendations
  FOR ALL
  USING (session_id IN (SELECT id FROM sessions WHERE user_id = auth.uid()));

-- Users can only see their own analytics
CREATE POLICY users_own_analytics ON analytics_events
  FOR ALL
  USING (user_id = auth.uid());

-- Prince songs are readable by all authenticated users
CREATE POLICY prince_songs_readable ON prince_songs
  FOR SELECT
  USING (auth.role() = 'authenticated');

-- ============================================
-- COMMENTS
-- ============================================

COMMENT ON TABLE users IS 'Application users with subscription tiers';
COMMENT ON TABLE sessions IS 'Voice capture sessions with 5-question limit';
COMMENT ON TABLE session_exchanges IS 'Individual question/answer pairs within sessions';
COMMENT ON TABLE canon_entries IS 'Structured brand insights extracted from sessions';
COMMENT ON TABLE prince_songs IS 'Database of Prince songs for recommendations';
COMMENT ON TABLE song_recommendations IS 'Prince song recommendations per session';
COMMENT ON TABLE analytics_events IS 'User activity tracking and metrics';

COMMENT ON COLUMN sessions.question_count IS 'Number of questions asked (max 5)';
COMMENT ON COLUMN canon_entries.audit_trail IS 'JSON array of edit history';
COMMENT ON COLUMN canon_entries.manually_edited IS 'True if user manually edited this entry';
COMMENT ON COLUMN prince_songs.is_deep_cut IS 'True for lesser-known tracks (anti-consensus)';
COMMENT ON COLUMN song_recommendations.user_rating IS '1 = thumbs down, 2 = thumbs up';

