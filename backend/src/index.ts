import { createApp } from './app';
import { config } from './config/env';
import { logger } from './config/logger';

const app = createApp();

const server = app.listen(config.port, () => {
  logger.info(`🎸 Razberry Beret API started`, {
    port: config.port,
    environment: config.nodeEnv,
    nodeVersion: process.version,
  });
  logger.info(`Health check available at http://localhost:${config.port}/health`);
});

// Graceful shutdown
process.on('SIGTERM', () => {
  logger.info('SIGTERM signal received: closing HTTP server');
  server.close(() => {
    logger.info('HTTP server closed');
    process.exit(0);
  });
});

process.on('SIGINT', () => {
  logger.info('SIGINT signal received: closing HTTP server');
  server.close(() => {
    logger.info('HTTP server closed');
    process.exit(0);
  });
});

// Handle uncaught errors
process.on('uncaughtException', (error: Error) => {
  logger.error('Uncaught Exception', { error: error.message, stack: error.stack });
  process.exit(1);
});

process.on('unhandledRejection', (reason: unknown) => {
  logger.error('Unhandled Rejection', { reason });
  process.exit(1);
});

