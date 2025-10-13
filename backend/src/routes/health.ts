import { Router, Request, Response } from 'express';
import { testSupabaseConnection } from '../config/supabase';
import { authService } from '../services/auth.service';
import { config } from '../config/env';

const router = Router();

/**
 * GET /health
 * Health check endpoint
 */
router.get('/', async (_req: Request, res: Response) => {
  const supabaseConnected = await testSupabaseConnection();
  const authConnected = await authService.testConnection();
  
  const health = {
    status: 'ok',
    timestamp: new Date().toISOString(),
    uptime: process.uptime(),
    environment: config.nodeEnv,
    services: {
      supabase: supabaseConnected ? 'connected' : 'disconnected',
      auth: authConnected ? 'connected' : 'disconnected',
    },
  };

  const statusCode = (supabaseConnected && authConnected) ? 200 : 503;
  
  res.status(statusCode).json({
    success: true,
    data: health,
  });
});

export default router;

