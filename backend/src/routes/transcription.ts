import { Router, Request, Response } from 'express';
import multer from 'multer';
import { whisperService } from '../services/whisper.service';
import { logger } from '../config/logger';
import fs from 'fs/promises';

const router = Router();

// Configure multer for file uploads
const upload = multer({
  dest: 'uploads/',
  limits: {
    fileSize: 25 * 1024 * 1024, // 25MB max (Whisper limit)
  },
  fileFilter: (_req, file, cb) => {
    const ext = file.originalname.split('.').pop()?.toLowerCase() || '';
    
    if (whisperService.isFormatSupported(ext)) {
      cb(null, true);
    } else {
      cb(new Error(`Unsupported audio format: ${ext}`));
    }
  },
});

/**
 * GET /test
 * Test Whisper API connectivity
 */
router.get('/test', async (_req: Request, res: Response) => {
  try {
    const isConnected = await whisperService.testConnection();
    
    res.json({
      success: true,
      data: {
        connected: isConnected,
        supportedFormats: whisperService.getSupportedFormats(),
        model: 'whisper-1',
      },
    });
  } catch (error) {
    logger.error('Whisper test endpoint error', { error });
    res.status(500).json({
      success: false,
      error: {
        message: 'Failed to test Whisper API connection',
      },
    });
  }
});

/**
 * POST /transcribe
 * Transcribe an audio file
 */
router.post('/transcribe', upload.single('audio'), async (req: Request, res: Response) => {
  let filePath: string | undefined;

  try {
    if (!req.file) {
      res.status(400).json({
        success: false,
        error: {
          message: 'No audio file provided. Please upload a file with key "audio".',
        },
      });
      return;
    }

    filePath = req.file.path;
    const language = req.body.language as string | undefined;
    const prompt = req.body.prompt as string | undefined;

    logger.info('Transcription request received', {
      originalName: req.file.originalname,
      size: req.file.size,
      mimetype: req.file.mimetype,
      language,
    });

    const result = await whisperService.transcribeFile(filePath, {
      language,
      prompt,
    });

    // Clean up uploaded file
    await fs.unlink(filePath);

    res.json({
      success: true,
      data: result,
    });
  } catch (error) {
    // Clean up file if it exists
    if (filePath) {
      try {
        await fs.unlink(filePath);
      } catch (unlinkError) {
        logger.warn('Failed to clean up uploaded file', { filePath, unlinkError });
      }
    }

    logger.error('Transcription endpoint error', { error });
    
    const errorMessage = error instanceof Error ? error.message : 'Transcription failed';
    
    res.status(500).json({
      success: false,
      error: {
        message: errorMessage,
      },
    });
  }
});

/**
 * GET /formats
 * Get list of supported audio formats
 */
router.get('/formats', (_req: Request, res: Response) => {
  res.json({
    success: true,
    data: {
      supportedFormats: whisperService.getSupportedFormats(),
      maxFileSize: '25MB',
    },
  });
});

export default router;

