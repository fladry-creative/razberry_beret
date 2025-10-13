import express, { Application } from 'express';
import cors from 'cors';
import helmet from 'helmet';
import morgan from 'morgan';
import { config } from './config/env';
import { logger } from './config/logger';
import { errorHandler, notFoundHandler } from './middleware/errorHandler';
import healthRouter from './routes/health';
import anthropicRouter from './routes/anthropic';
import transcriptionRouter from './routes/transcription';
import authRouter from './routes/auth';

export function createApp(): Application {
  const app: Application = express();

  // Security middleware
  app.use(helmet());
  
  // CORS configuration
  app.use(cors({
    origin: config.nodeEnv === 'development' ? '*' : [], // Configure for production
    credentials: true,
  }));

  // Body parsing middleware
  app.use(express.json());
  app.use(express.urlencoded({ extended: true }));

  // HTTP request logging
  if (config.nodeEnv === 'development') {
    app.use(morgan('dev'));
  } else {
    app.use(morgan('combined', {
      stream: {
        write: (message: string) => logger.info(message.trim()),
      },
    }));
  }

  // Routes
  app.use('/health', healthRouter);
  app.use('/api/v1/auth', authRouter);
  app.use('/api/v1/anthropic', anthropicRouter);
  app.use('/api/v1/transcription', transcriptionRouter);
  
  // Future routes will be added here:
  // app.use('/api/v1/sessions', sessionsRouter);
  // app.use('/api/v1/canon', canonRouter);

  // 404 handler
  app.use(notFoundHandler);

  // Error handler (must be last)
  app.use(errorHandler);

  return app;
}

