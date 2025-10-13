-- Razberry Beret - Prince Songs Database
-- 50+ deep cuts from Prince's catalog
-- Intentionally avoiding mainstream hits (Raspberry Beret, Purple Rain, etc.)
-- to detect AI drift toward consensus

-- Clear existing data (for re-running)
TRUNCATE prince_songs CASCADE;

INSERT INTO prince_songs (title, album, year, is_deep_cut, mood_tags, reasoning_template) VALUES

-- Deep Cuts from Different Eras
('Alphabet St.', 'Lovesexy', 1988, true, ARRAY['playful', 'confident', 'energetic'], 'When you''re feeling bold and ready to shake things up'),
('Controversy', 'Controversy', 1981, true, ARRAY['provocative', 'defiant', 'funky'], 'For challenging the status quo without apology'),
('Housequake', 'Sign O'' The Times', 1987, true, ARRAY['powerful', 'assertive', 'bold'], 'When your ideas are too big to contain'),
('The Ballad of Dorothy Parker', 'Sign O'' The Times', 1987, true, ARRAY['surreal', 'dreamy', 'introspective'], 'For those moments of unexpected connection'),
('Starfish and Coffee', 'Sign O'' The Times', 1987, true, ARRAY['whimsical', 'creative', 'unique'], 'Celebrating the beautifully unconventional'),

('It''s Gonna Be a Beautiful Night', 'Sign O'' The Times', 1987, true, ARRAY['celebratory', 'communal', 'joyful'], 'When the team is vibing and everything clicks'),
('Thieves in the Temple', 'Graffiti Bridge', 1990, true, ARRAY['mysterious', 'intense', 'spiritual'], 'Protecting what''s sacred from those who don''t get it'),
('Mountains', 'Parade', 1986, true, ARRAY['uplifting', 'determined', 'optimistic'], 'For overcoming obstacles that seemed impossible'),
('Batdance', 'Batman Soundtrack', 1989, true, ARRAY['chaotic', 'experimental', 'bold'], 'When you''re juggling multiple identities or visions'),
('Girls & Boys', 'Parade', 1986, true, ARRAY['playful', 'collaborative', 'harmonious'], 'Finding balance between different perspectives'),

('New Position', 'Parade', 1986, true, ARRAY['seductive', 'innovative', 'daring'], 'Proposing a completely different approach'),
('Christopher Tracy''s Parade', 'Parade', 1986, true, ARRAY['theatrical', 'grand', 'celebratory'], 'When it''s time to show the world what you''ve built'),
('Sometimes It Snows in April', 'Parade', 1986, true, ARRAY['melancholic', 'reflective', 'beautiful'], 'Processing loss while maintaining grace'),
('17 Days', 'B-side Single', 1984, true, ARRAY['patient', 'yearning', 'soulful'], 'Playing the long game when instant gratification won''t work'),
('Electric Chair', 'Batman Soundtrack', 1989, true, ARRAY['dangerous', 'thrilling', 'edgy'], 'Taking risks that others consider reckless'),

('Scandalous', 'Batman Soundtrack', 1989, true, ARRAY['sultry', 'confident', 'provocative'], 'When being conventional would be the real scandal'),
('The Beautiful Ones', 'Purple Rain', 1984, false, ARRAY['vulnerable', 'passionate', 'desperate'], 'Making your case with everything you''ve got'),
('Computer Blue', 'Purple Rain', 1984, false, ARRAY['intense', 'raw', 'emotional'], 'Feeling the weight of complexity and depth'),
('Darling Nikki', 'Purple Rain', 1984, true, ARRAY['rebellious', 'shocking', 'defiant'], 'Breaking taboos and not caring about the backlash'),
('Let''s Go Crazy', 'Purple Rain', 1984, false, ARRAY['manic', 'liberating', 'wild'], 'Embracing chaos as the path forward'),

('Pop Life', 'Around the World in a Day', 1985, true, ARRAY['satirical', 'observant', 'funky'], 'Calling out superficiality with style'),
('Paisley Park', 'Around the World in a Day', 1985, true, ARRAY['utopian', 'dreamy', 'escapist'], 'Creating your own reality when the current one won''t do'),
('Condition of the Heart', 'Around the World in a Day', 1985, true, ARRAY['tender', 'vulnerable', 'sincere'], 'Admitting the emotional stakes are real'),
('Sign O'' the Times', 'Sign O'' The Times', 1987, true, ARRAY['socially_conscious', 'urgent', 'wise'], 'Seeing the bigger picture while others focus on noise'),
('I Could Never Take the Place of Your Man', 'Sign O'' The Times', 1987, true, ARRAY['honest', 'respectful', 'bittersweet'], 'Knowing your limits and being upfront about them'),

('U Got the Look', 'Sign O'' The Times', 1987, false, ARRAY['attractive', 'confident', 'magnetic'], 'When the aesthetic is as important as the substance'),
('Forever in My Life', 'Sign O'' The Times', 1987, true, ARRAY['devoted', 'eternal', 'romantic'], 'Committing fully to the vision, for better or worse'),
('Hot Thing', 'Sign O'' The Times', 1987, true, ARRAY['sensual', 'direct', 'bold'], 'Going after exactly what you want'),
('Adore', 'Sign O'' The Times', 1987, true, ARRAY['intimate', 'reverent', 'worshipful'], 'Deep appreciation for what you''ve built together'),
('Money Don''t Matter 2 Night', 'Diamonds and Pearls', 1991, true, ARRAY['philosophical', 'grounded', 'wise'], 'Keeping perspective on what actually matters'),

('Cream', 'Diamonds and Pearls', 1991, false, ARRAY['smooth', 'confident', 'stylish'], 'Rising to the top effortlessly'),
('Gett Off', 'Diamonds and Pearls', 1991, true, ARRAY['aggressive', 'demanding', 'uncompromising'], 'Making bold demands without apology'),
('Insatiable', 'Diamonds and Pearls', 1991, true, ARRAY['hungry', 'ambitious', 'relentless'], 'Never satisfied with good enough'),
('Diamonds and Pearls', 'Diamonds and Pearls', 1991, false, ARRAY['romantic', 'aspirational', 'luxurious'], 'Offering something truly valuable'),
('7', '(Love Symbol)', 1992, true, ARRAY['spiritual', 'mystical', 'prophetic'], 'Believing in forces bigger than quarterly metrics'),

('The Most Beautiful Girl in the World', 'The Gold Experience', 1995, false, ARRAY['awestruck', 'devoted', 'appreciative'], 'Recognizing pure excellence when you see it'),
('Gold', 'The Gold Experience', 1995, true, ARRAY['triumphant', 'valuable', 'precious'], 'Achieving something genuinely rare and valuable'),
('P. Control', 'Emancipation', 1996, true, ARRAY['empowered', 'autonomous', 'fierce'], 'Taking full control of your destiny'),
('Betcha By Golly Wow!', 'Emancipation', 1996, true, ARRAY['surprised', 'delighted', 'amazed'], 'Exceeding even your own expectations'),
('Face Down', 'Emancipation', 1996, true, ARRAY['determined', 'unstoppable', 'focused'], 'Powering through obstacles with pure will'),

('The One', 'Emancipation', 1996, true, ARRAY['certain', 'destined', 'confident'], 'Knowing this is exactly what the world needs'),
('Musicology', 'Musicology', 2004, true, ARRAY['educational', 'passionate', 'masterful'], 'Teaching others while staying true to the craft'),
('Call My Name', 'Musicology', 2004, true, ARRAY['available', 'reliable', 'supportive'], 'Being there when your users need you most'),
('Fury', '3121', 2006, true, ARRAY['intense', 'powerful', 'unleashed'], 'Channeling anger into productive action'),
('Black Sweat', '3121', 2006, true, ARRAY['gritty', 'hardworking', 'authentic'], 'Putting in the work when others are all talk'),

('Chelsea Rodgers', 'Planet Earth', 2007, true, ARRAY['narrative', 'character_driven', 'storytelling'], 'Every user has a story worth understanding'),
('Guitar', 'Planet Earth', 2007, true, ARRAY['skilled', 'expressive', 'virtuosic'], 'Let your expertise speak for itself'),
('Hot Summer', 'Lotusflow3r', 2009, true, ARRAY['sensual', 'seasonal', 'alive'], 'Timing is everything—strike when the moment is right'),
('Colonized Mind', 'Lotusflow3r', 2009, true, ARRAY['awakening', 'rebellious', 'liberating'], 'Breaking free from inherited assumptions'),
('Cause and Effect', 'Lotusflow3r', 2009, true, ARRAY['logical', 'consequential', 'interconnected'], 'Every decision ripples outward'),

('Screwdriver', 'Art Official Age', 2014, true, ARRAY['building', 'fixing', 'hands_on'], 'Sometimes you need the right tool for the job'),
('Clouds', 'Art Official Age', 2014, true, ARRAY['ethereal', 'floating', 'transcendent'], 'Rising above the daily noise'),
('Breakfast Can Wait', 'Single', 2013, true, ARRAY['patient', 'savoring', 'unhurried'], 'The best things happen when you''re not rushing');

-- Update statistics
ANALYZE prince_songs;

-- Verify the data
SELECT 
  COUNT(*) as total_songs,
  COUNT(*) FILTER (WHERE is_deep_cut = true) as deep_cuts,
  COUNT(*) FILTER (WHERE is_deep_cut = false) as mainstream,
  MIN(year) as earliest_year,
  MAX(year) as latest_year
FROM prince_songs;

