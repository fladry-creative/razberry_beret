import { Request, Response, NextFunction } from 'express';
import { authService, User } from '../services/auth.service';
import { logger } from '../config/logger';

/**
 * Extend Express Request interface to include user
 */
declare global {
  namespace Express {
    interface Request {
      user?: User;
    }
  }
}

/**
 * Authentication middleware
 * Validates JWT token and attaches user to request
 */
export async function requireAuth(req: Request, res: Response, next: NextFunction): Promise<void> {
  try {
    // Get token from Authorization header
    const authHeader = req.headers.authorization;
    
    if (!authHeader) {
      logger.debug('No authorization header provided');
      res.status(401).json({
        success: false,
        error: {
          message: 'No authorization header provided',
          code: 'MISSING_AUTH_HEADER',
        },
      });
      return;
    }

    // Extract Bearer token
    const token = authHeader.split(' ')[1];
    
    if (!token) {
      logger.debug('No token found in authorization header');
      res.status(401).json({
        success: false,
        error: {
          message: 'Invalid authorization header format. Use: Bearer <token>',
          code: 'INVALID_AUTH_HEADER',
        },
      });
      return;
    }

    // Validate token and get user
    const user = await authService.validateToken(token);
    
    if (!user) {
      logger.debug('Token validation failed', { 
        tokenPrefix: token.substring(0, 10) + '...' 
      });
      res.status(401).json({
        success: false,
        error: {
          message: 'Invalid or expired token',
          code: 'INVALID_TOKEN',
        },
      });
      return;
    }

    // Attach user to request
    req.user = user;
    
    logger.debug('User authenticated successfully', { 
      userId: user.id, 
      email: user.email 
    });

    next();
  } catch (error) {
    logger.error('Auth middleware error', { error });
    res.status(500).json({
      success: false,
      error: {
        message: 'Authentication error',
        code: 'AUTH_ERROR',
      },
    });
  }
}

/**
 * Optional authentication middleware
 * Attaches user to request if token is valid, but doesn't require it
 */
export async function optionalAuth(req: Request, _res: Response, next: NextFunction): Promise<void> {
  try {
    const authHeader = req.headers.authorization;
    
    if (!authHeader) {
      return next();
    }

    const token = authHeader.split(' ')[1];
    
    if (!token) {
      return next();
    }

    const user = await authService.validateToken(token);
    
    if (user) {
      req.user = user;
      logger.debug('Optional auth: user found', { userId: user.id });
    }

    next();
  } catch (error) {
    logger.error('Optional auth middleware error', { error });
    // Don't fail on optional auth errors
    next();
  }
}

/**
 * Extract user ID from request (requires auth middleware)
 */
export function getUserId(req: Request): string {
  if (!req.user?.id) {
    throw new Error('User not authenticated');
  }
  return req.user.id;
}

/**
 * Check if user is authenticated
 */
export function isAuthenticated(req: Request): boolean {
  return !!req.user?.id;
}
