import { Router, Request, Response } from 'express';
import { anthropicService } from '../services/anthropic.service';
import { logger } from '../config/logger';
import { requireAuth } from '../middleware/auth.middleware';

const router = Router();

/**
 * GET /test
 * Test Anthropic API connectivity
 */
router.get('/test', async (_req: Request, res: Response) => {
  try {
    const isConnected = await anthropicService.testConnection();
    
    res.json({
      success: true,
      data: {
        connected: isConnected,
        model: anthropicService.getModelInfo(),
      },
    });
  } catch (error) {
    logger.error('Anthropic test endpoint error', { error });
    res.status(500).json({
      success: false,
      error: {
        message: 'Failed to test Anthropic API connection',
      },
    });
  }
});

/**
 * POST /generate-question
 * Generate a question for session flow
 */
router.post('/generate-question', requireAuth, async (req: Request, res: Response) => {
  try {
    const { userResponse, sessionContext } = req.body;
    
    const question = await anthropicService.generateQuestion(
      userResponse,
      sessionContext
    );
    
    res.json({
      success: true,
      data: { question },
    });
  } catch (error) {
    logger.error('Question generation error', { error });
    res.status(500).json({
      success: false,
      error: {
        message: 'Failed to generate question',
      },
    });
  }
});

export default router;

