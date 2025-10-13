import { createClient } from '@supabase/supabase-js';
import { config } from './env';
import { logger } from './logger';

/**
 * Supabase client with anon key (for client-side operations)
 */
export const supabase = createClient(config.supabase.url, config.supabase.anonKey);

/**
 * Supabase admin client with service key (for server-side operations)
 * This bypasses Row Level Security policies
 */
export const supabaseAdmin = createClient(config.supabase.url, config.supabase.serviceKey);

/**
 * Test Supabase connection
 */
export async function testSupabaseConnection(): Promise<boolean> {
  try {
    // Simple query to test connection
    const { error } = await supabase.from('_test_').select('*').limit(1);
    
    // If table doesn't exist, that's okay - we're just testing connection
    if (error && !error.message.includes('does not exist')) {
      logger.error('Supabase connection test failed', { error: error.message });
      return false;
    }
    
    logger.info('Supabase connection successful');
    return true;
  } catch (error) {
    logger.error('Supabase connection test failed', { error });
    return false;
  }
}

