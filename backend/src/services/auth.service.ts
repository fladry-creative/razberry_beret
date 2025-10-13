import { supabase, supabaseAdmin } from '../config/supabase';
import { logger } from '../config/logger';

/**
 * User data structure
 */
export interface User {
  id: string;
  email: string;
  created_at: string;
}

/**
 * Auth response structure
 */
export interface AuthResponse {
  user: User | null;
  session: {
    access_token: string;
    refresh_token: string;
    expires_at: number;
  } | null;
}

/**
 * Registration request
 */
export interface RegisterRequest {
  email: string;
  password: string;
}

/**
 * Login request
 */
export interface LoginRequest {
  email: string;
  password: string;
}

/**
 * Authentication Service
 * Wrapper for Supabase Auth functionality
 */
export class AuthService {
  
  /**
   * Register a new user
   */
  async register(data: RegisterRequest): Promise<AuthResponse> {
    try {
      logger.info('Attempting user registration', { email: data.email });

      const { data: authData, error } = await supabase.auth.signUp({
        email: data.email,
        password: data.password,
      });

      if (error) {
        logger.error('Registration failed', { error: error.message, email: data.email });
        throw new Error(`Registration failed: ${error.message}`);
      }

      if (!authData.user) {
        throw new Error('Registration succeeded but no user returned');
      }

      // Create user record in our users table
      await this.createUserRecord(authData.user.id, data.email);

      logger.info('User registered successfully', { 
        userId: authData.user.id, 
        email: data.email 
      });

      return {
        user: authData.user ? {
          id: authData.user.id,
          email: authData.user.email || data.email,
          created_at: authData.user.created_at || new Date().toISOString(),
        } : null,
        session: authData.session ? {
          access_token: authData.session.access_token,
          refresh_token: authData.session.refresh_token,
          expires_at: authData.session.expires_at || 0,
        } : null,
      };
    } catch (error) {
      logger.error('Registration error', { error, email: data.email });
      throw error;
    }
  }

  /**
   * Login user
   */
  async login(data: LoginRequest): Promise<AuthResponse> {
    try {
      logger.info('Attempting user login', { email: data.email });

      const { data: authData, error } = await supabase.auth.signInWithPassword({
        email: data.email,
        password: data.password,
      });

      if (error) {
        logger.error('Login failed', { error: error.message, email: data.email });
        throw new Error(`Login failed: ${error.message}`);
      }

      logger.info('User logged in successfully', { 
        userId: authData.user?.id, 
        email: data.email 
      });

      return {
        user: authData.user ? {
          id: authData.user.id,
          email: authData.user.email || data.email,
          created_at: authData.user.created_at || new Date().toISOString(),
        } : null,
        session: authData.session ? {
          access_token: authData.session.access_token,
          refresh_token: authData.session.refresh_token,
          expires_at: authData.session.expires_at || 0,
        } : null,
      };
    } catch (error) {
      logger.error('Login error', { error, email: data.email });
      throw error;
    }
  }

  /**
   * Logout user
   */
  async logout(): Promise<void> {
    try {
      logger.info('Attempting user logout');

      const { error } = await supabase.auth.signOut();

      if (error) {
        logger.error('Logout failed', { error: error.message });
        throw new Error(`Logout failed: ${error.message}`);
      }

      logger.info('User logged out successfully');
    } catch (error) {
      logger.error('Logout error', { error });
      throw error;
    }
  }

  /**
   * Refresh access token
   */
  async refreshToken(refreshToken: string): Promise<AuthResponse> {
    try {
      logger.info('Attempting token refresh');

      const { data: authData, error } = await supabase.auth.refreshSession({
        refresh_token: refreshToken,
      });

      if (error) {
        logger.error('Token refresh failed', { error: error.message });
        throw new Error(`Token refresh failed: ${error.message}`);
      }

      logger.info('Token refreshed successfully', { 
        userId: authData.user?.id 
      });

      return {
        user: authData.user ? {
          id: authData.user.id,
          email: authData.user.email || '',
          created_at: authData.user.created_at || new Date().toISOString(),
        } : null,
        session: authData.session ? {
          access_token: authData.session.access_token,
          refresh_token: authData.session.refresh_token,
          expires_at: authData.session.expires_at || 0,
        } : null,
      };
    } catch (error) {
      logger.error('Token refresh error', { error });
      throw error;
    }
  }

  /**
   * Validate access token and get user
   */
  async validateToken(token: string): Promise<User | null> {
    try {
      const { data: userData, error } = await supabase.auth.getUser(token);

      if (error || !userData.user) {
        logger.debug('Token validation failed', { error: error?.message });
        return null;
      }

      return {
        id: userData.user.id,
        email: userData.user.email || '',
        created_at: userData.user.created_at || new Date().toISOString(),
      };
    } catch (error) {
      logger.error('Token validation error', { error });
      return null;
    }
  }

  /**
   * Get user by ID (admin function)
   */
  async getUserById(userId: string): Promise<User | null> {
    try {
      const { data: userData, error } = await supabaseAdmin.auth.admin.getUserById(userId);

      if (error || !userData.user) {
        logger.error('Failed to get user by ID', { error: error?.message, userId });
        return null;
      }

      return {
        id: userData.user.id,
        email: userData.user.email || '',
        created_at: userData.user.created_at || new Date().toISOString(),
      };
    } catch (error) {
      logger.error('Get user by ID error', { error, userId });
      return null;
    }
  }

  /**
   * Create user record in our users table
   * This syncs Supabase Auth user with our application user table
   */
  private async createUserRecord(userId: string, email: string): Promise<void> {
    try {
      const { error } = await supabaseAdmin
        .from('users')
        .insert({
          id: userId,
          email: email,
          subscription_tier: 'free',
          total_sessions: 0,
          settings: {},
        });

      if (error) {
        // Check if it's a duplicate key error (user already exists)
        if (error.code === '23505') {
          logger.info('User record already exists', { userId, email });
          return;
        }
        
        logger.error('Failed to create user record', { error, userId, email });
        throw new Error(`Failed to create user record: ${error.message}`);
      }

      logger.info('User record created successfully', { userId, email });
    } catch (error) {
      logger.error('Create user record error', { error, userId, email });
      throw error;
    }
  }

  /**
   * Test auth service connectivity
   */
  async testConnection(): Promise<boolean> {
    try {
      // Try to get the current session
      const { data, error } = await supabase.auth.getSession();
      
      if (error) {
        logger.error('Auth service test failed', { error: error.message });
        return false;
      }

      logger.info('Auth service test successful', { 
        hasSession: !!data.session 
      });
      return true;
    } catch (error) {
      logger.error('Auth service test error', { error });
      return false;
    }
  }
}

// Export singleton instance
export const authService = new AuthService();
