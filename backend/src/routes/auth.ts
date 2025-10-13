import { Router, Request, Response } from 'express';
import { authService, RegisterRequest, LoginRequest } from '../services/auth.service';
import { logger } from '../config/logger';
import { requireAuth } from '../middleware/auth.middleware';

const router = Router();

/**
 * POST /register
 * Register a new user
 */
router.post('/register', async (req: Request, res: Response) => {
  try {
    const { email, password }: RegisterRequest = req.body;

    // Validate input
    if (!email || !password) {
      res.status(400).json({
        success: false,
        error: {
          message: 'Email and password are required',
          code: 'MISSING_FIELDS',
        },
      });
      return;
    }

    // Basic email validation
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(email)) {
      res.status(400).json({
        success: false,
        error: {
          message: 'Invalid email format',
          code: 'INVALID_EMAIL',
        },
      });
      return;
    }

    // Password strength validation
    if (password.length < 8) {
      res.status(400).json({
        success: false,
        error: {
          message: 'Password must be at least 8 characters long',
          code: 'WEAK_PASSWORD',
        },
      });
      return;
    }

    logger.info('Registration attempt', { email });

    const result = await authService.register({ email, password });

    res.status(201).json({
      success: true,
      data: {
        user: result.user,
        session: result.session,
        message: 'Registration successful',
      },
    });
  } catch (error) {
    logger.error('Registration endpoint error', { error });
    
    const errorMessage = error instanceof Error ? error.message : 'Registration failed';
    
    res.status(400).json({
      success: false,
      error: {
        message: errorMessage,
        code: 'REGISTRATION_FAILED',
      },
    });
  }
});

/**
 * POST /login
 * Login existing user
 */
router.post('/login', async (req: Request, res: Response) => {
  try {
    const { email, password }: LoginRequest = req.body;

    // Validate input
    if (!email || !password) {
      res.status(400).json({
        success: false,
        error: {
          message: 'Email and password are required',
          code: 'MISSING_FIELDS',
        },
      });
      return;
    }

    logger.info('Login attempt', { email });

    const result = await authService.login({ email, password });

    res.json({
      success: true,
      data: {
        user: result.user,
        session: result.session,
        message: 'Login successful',
      },
    });
  } catch (error) {
    logger.error('Login endpoint error', { error });
    
    const errorMessage = error instanceof Error ? error.message : 'Login failed';
    
    res.status(401).json({
      success: false,
      error: {
        message: errorMessage,
        code: 'LOGIN_FAILED',
      },
    });
  }
});

/**
 * POST /logout
 * Logout current user
 */
router.post('/logout', requireAuth, async (req: Request, res: Response) => {
  try {
    logger.info('Logout attempt', { userId: req.user?.id });

    await authService.logout();

    res.json({
      success: true,
      data: {
        message: 'Logout successful',
      },
    });
  } catch (error) {
    logger.error('Logout endpoint error', { error });
    
    const errorMessage = error instanceof Error ? error.message : 'Logout failed';
    
    res.status(400).json({
      success: false,
      error: {
        message: errorMessage,
        code: 'LOGOUT_FAILED',
      },
    });
  }
});

/**
 * POST /refresh
 * Refresh access token
 */
router.post('/refresh', async (req: Request, res: Response) => {
  try {
    const { refresh_token } = req.body;

    if (!refresh_token) {
      res.status(400).json({
        success: false,
        error: {
          message: 'Refresh token is required',
          code: 'MISSING_REFRESH_TOKEN',
        },
      });
      return;
    }

    logger.info('Token refresh attempt');

    const result = await authService.refreshToken(refresh_token);

    res.json({
      success: true,
      data: {
        user: result.user,
        session: result.session,
        message: 'Token refreshed successfully',
      },
    });
  } catch (error) {
    logger.error('Token refresh endpoint error', { error });
    
    const errorMessage = error instanceof Error ? error.message : 'Token refresh failed';
    
    res.status(401).json({
      success: false,
      error: {
        message: errorMessage,
        code: 'REFRESH_FAILED',
      },
    });
  }
});

/**
 * GET /me
 * Get current user information
 */
router.get('/me', requireAuth, async (req: Request, res: Response) => {
  try {
    res.json({
      success: true,
      data: {
        user: req.user,
      },
    });
  } catch (error) {
    logger.error('Get user endpoint error', { error });
    
    res.status(500).json({
      success: false,
      error: {
        message: 'Failed to get user information',
        code: 'GET_USER_FAILED',
      },
    });
  }
});

/**
 * GET /test
 * Test auth service connectivity
 */
router.get('/test', async (_req: Request, res: Response) => {
  try {
    const isConnected = await authService.testConnection();
    
    res.json({
      success: true,
      data: {
        connected: isConnected,
        service: 'supabase-auth',
      },
    });
  } catch (error) {
    logger.error('Auth test endpoint error', { error });
    res.status(500).json({
      success: false,
      error: {
        message: 'Failed to test auth service',
      },
    });
  }
});

export default router;
