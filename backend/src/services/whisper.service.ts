import OpenAI from 'openai';
import { config } from '../config/env';
import { logger } from '../config/logger';
import fs from 'fs';
import path from 'path';

/**
 * Supported audio formats for Whisper API
 */
export type AudioFormat = 'flac' | 'mp3' | 'mp4' | 'mpeg' | 'mpga' | 'm4a' | 'ogg' | 'wav' | 'webm';

/**
 * Transcription result with metadata
 */
export interface TranscriptionResult {
  text: string;
  duration?: number;
  language?: string;
  confidence?: number;
}

/**
 * Whisper API Service
 * Wrapper for OpenAI Whisper voice transcription
 */
export class WhisperService {
  private client: OpenAI;
  private readonly model: string = 'whisper-1';
  private readonly maxRetries: number = 3;
  private readonly supportedFormats: AudioFormat[] = [
    'flac',
    'mp3',
    'mp4',
    'mpeg',
    'mpga',
    'm4a',
    'ogg',
    'wav',
    'webm',
  ];

  constructor() {
    this.client = new OpenAI({
      apiKey: config.openai.apiKey,
    });

    logger.info('Whisper service initialized', { model: this.model });
  }

  /**
   * Transcribe audio file to text
   */
  async transcribeFile(
    filePath: string,
    options?: {
      language?: string;
      prompt?: string;
      temperature?: number;
      retryCount?: number;
    }
  ): Promise<TranscriptionResult> {
    const retryCount = options?.retryCount || 0;

    try {
      // Validate file exists
      if (!fs.existsSync(filePath)) {
        throw new Error(`Audio file not found: ${filePath}`);
      }

      // Validate file format
      const ext = path.extname(filePath).toLowerCase().slice(1) as AudioFormat;
      if (!this.supportedFormats.includes(ext)) {
        throw new Error(
          `Unsupported audio format: ${ext}. Supported: ${this.supportedFormats.join(', ')}`
        );
      }

      logger.debug('Transcribing audio file', {
        filePath,
        format: ext,
        language: options?.language,
      });

      const fileStream = fs.createReadStream(filePath);

      const transcription = await this.client.audio.transcriptions.create({
        file: fileStream,
        model: this.model,
        language: options?.language,
        prompt: options?.prompt,
        temperature: options?.temperature || 0,
        response_format: 'verbose_json',
      });

      logger.info('Transcription completed successfully', {
        textLength: transcription.text.length,
        duration: transcription.duration,
        language: transcription.language,
      });

      return {
        text: transcription.text,
        duration: transcription.duration,
        language: transcription.language,
      };
    } catch (error) {
      return this.handleError(error, retryCount, filePath, options);
    }
  }

  /**
   * Transcribe audio buffer to text
   * Useful for in-memory audio data
   */
  async transcribeBuffer(
    buffer: Buffer,
    filename: string,
    options?: {
      language?: string;
      prompt?: string;
      temperature?: number;
      retryCount?: number;
    }
  ): Promise<TranscriptionResult> {
    const retryCount = options?.retryCount || 0;

    try {
      // Validate file format from filename
      const ext = path.extname(filename).toLowerCase().slice(1) as AudioFormat;
      if (!this.supportedFormats.includes(ext)) {
        throw new Error(
          `Unsupported audio format: ${ext}. Supported: ${this.supportedFormats.join(', ')}`
        );
      }

      logger.debug('Transcribing audio buffer', {
        filename,
        bufferSize: buffer.length,
        format: ext,
      });

      // Create a File-like object from buffer
      const file = new File([buffer], filename, {
        type: `audio/${ext}`,
      });

      const transcription = await this.client.audio.transcriptions.create({
        file: file,
        model: this.model,
        language: options?.language,
        prompt: options?.prompt,
        temperature: options?.temperature || 0,
        response_format: 'verbose_json',
      });

      logger.info('Buffer transcription completed', {
        textLength: transcription.text.length,
        duration: transcription.duration,
      });

      return {
        text: transcription.text,
        duration: transcription.duration,
        language: transcription.language,
      };
    } catch (error) {
      return this.handleBufferError(error, retryCount, buffer, filename, options);
    }
  }

  /**
   * Test API connectivity
   */
  async testConnection(): Promise<boolean> {
    try {
      // We can't easily test Whisper without an audio file
      // So we just verify the API key is set
      if (!config.openai.apiKey || config.openai.apiKey.includes('placeholder')) {
        logger.warn('OpenAI API key not configured');
        return false;
      }

      logger.info('Whisper API configuration validated');
      return true;
    } catch (error) {
      logger.error('Whisper API connection test failed', { error });
      return false;
    }
  }

  /**
   * Get supported audio formats
   */
  getSupportedFormats(): AudioFormat[] {
    return [...this.supportedFormats];
  }

  /**
   * Validate if audio format is supported
   */
  isFormatSupported(format: string): boolean {
    return this.supportedFormats.includes(format.toLowerCase() as AudioFormat);
  }

  /**
   * Handle errors with retry logic
   */
  private async handleError(
    error: unknown,
    retryCount: number,
    filePath: string,
    options?: {
      language?: string;
      prompt?: string;
      temperature?: number;
    }
  ): Promise<TranscriptionResult> {
    const errorMessage = error instanceof Error ? error.message : 'Unknown error';

    logger.error('Whisper transcription error', {
      error: errorMessage,
      filePath,
      retryCount,
      maxRetries: this.maxRetries,
    });

    // Check if we should retry
    if (retryCount < this.maxRetries) {
      // Exponential backoff: 1s, 2s, 4s
      const backoffMs = Math.pow(2, retryCount) * 1000;

      logger.info('Retrying Whisper transcription', {
        retryCount: retryCount + 1,
        backoffMs,
      });

      await new Promise((resolve) => setTimeout(resolve, backoffMs));

      return this.transcribeFile(filePath, {
        ...options,
        retryCount: retryCount + 1,
      });
    }

    // Max retries exceeded
    throw new Error(`Whisper transcription failed after ${this.maxRetries} retries: ${errorMessage}`);
  }

  /**
   * Handle buffer transcription errors
   */
  private async handleBufferError(
    error: unknown,
    retryCount: number,
    buffer: Buffer,
    filename: string,
    options?: {
      language?: string;
      prompt?: string;
      temperature?: number;
    }
  ): Promise<TranscriptionResult> {
    const errorMessage = error instanceof Error ? error.message : 'Unknown error';

    logger.error('Whisper buffer transcription error', {
      error: errorMessage,
      filename,
      retryCount,
    });

    if (retryCount < this.maxRetries) {
      const backoffMs = Math.pow(2, retryCount) * 1000;

      logger.info('Retrying buffer transcription', {
        retryCount: retryCount + 1,
        backoffMs,
      });

      await new Promise((resolve) => setTimeout(resolve, backoffMs));

      return this.transcribeBuffer(buffer, filename, {
        ...options,
        retryCount: retryCount + 1,
      });
    }

    throw new Error(`Buffer transcription failed after ${this.maxRetries} retries: ${errorMessage}`);
  }
}

// Export singleton instance
export const whisperService = new WhisperService();

