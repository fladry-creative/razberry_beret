import Anthropic from '@anthropic-ai/sdk';
import { config } from '../config/env';
import { logger } from '../config/logger';

/**
 * Rate limiter for API calls
 */
class RateLimiter {
  private requests: number[] = [];
  private readonly maxRequests: number;
  private readonly windowMs: number;

  constructor(maxRequests: number = 50, windowMs: number = 60000) {
    this.maxRequests = maxRequests;
    this.windowMs = windowMs;
  }

  async waitForSlot(): Promise<void> {
    const now = Date.now();
    
    // Remove old requests outside the time window
    this.requests = this.requests.filter((time) => now - time < this.windowMs);

    if (this.requests.length >= this.maxRequests) {
      const oldestRequest = this.requests[0];
      const waitTime = this.windowMs - (now - oldestRequest);
      
      logger.warn('Rate limit reached, waiting', { waitTimeMs: waitTime });
      await new Promise((resolve) => setTimeout(resolve, waitTime));
      
      return this.waitForSlot(); // Recursive call after waiting
    }

    this.requests.push(now);
  }

  reset(): void {
    this.requests = [];
  }
}

/**
 * Anthropic API Service
 * Wrapper for Claude Sonnet 4.5 interactions
 */
export class AnthropicService {
  private client: Anthropic;
  private rateLimiter: RateLimiter;
  private readonly model: string = 'claude-sonnet-4-20250514';
  private readonly maxRetries: number = 3;

  constructor() {
    this.client = new Anthropic({
      apiKey: config.anthropic.apiKey,
    });
    
    // Configure rate limiter: 50 requests per minute (Anthropic's default)
    this.rateLimiter = new RateLimiter(50, 60000);
    
    logger.info('Anthropic service initialized', { model: this.model });
  }

  /**
   * Generate a completion with retry logic
   */
  async generateCompletion(
    systemPrompt: string,
    userMessage: string,
    options?: {
      maxTokens?: number;
      temperature?: number;
      retryCount?: number;
    }
  ): Promise<string> {
    const retryCount = options?.retryCount || 0;

    try {
      // Wait for rate limit slot
      await this.rateLimiter.waitForSlot();

      logger.debug('Generating completion', {
        systemPromptLength: systemPrompt.length,
        userMessageLength: userMessage.length,
        maxTokens: options?.maxTokens || 1024,
      });

      const response = await this.client.messages.create({
        model: this.model,
        max_tokens: options?.maxTokens || 1024,
        temperature: options?.temperature || 0.7,
        system: systemPrompt,
        messages: [
          {
            role: 'user',
            content: userMessage,
          },
        ],
      });

      const content = response.content[0];
      
      if (content.type !== 'text') {
        throw new Error('Unexpected response type from Anthropic API');
      }

      logger.info('Completion generated successfully', {
        inputTokens: response.usage.input_tokens,
        outputTokens: response.usage.output_tokens,
      });

      return content.text;
    } catch (error) {
      return this.handleError(error, retryCount, systemPrompt, userMessage, options);
    }
  }

  /**
   * Generate a question for session flow
   * This will be expanded in later phases with Canon context
   */
  async generateQuestion(
    userResponse?: string,
    sessionContext?: string
  ): Promise<string> {
    const systemPrompt = `You are a thoughtful interviewer helping founders capture their authentic brand voice and vision. 
Your questions should be:
- Open-ended and thought-provoking
- Conversational, not corporate
- Designed to extract genuine insights
- One question at a time (never multiple questions)

Keep questions concise (1-2 sentences max).`;

    const userMessage = userResponse
      ? `Based on this response: "${userResponse}"\n\nContext: ${sessionContext || 'First question'}\n\nGenerate the next question.`
      : 'Generate an opening question for a founder about their company.';

    return this.generateCompletion(systemPrompt, userMessage, {
      maxTokens: 150,
      temperature: 0.8,
    });
  }

  /**
   * Generate session recap
   */
  async generateSessionRecap(
    exchanges: Array<{ question: string; answer: string }>
  ): Promise<string> {
    const systemPrompt = `You are summarizing a voice capture session with a founder. 
Create a 2-3 sentence recap that captures the key insights they shared.
Be concise and authentic to their voice.`;

    const exchangeText = exchanges
      .map((ex, idx) => `Q${idx + 1}: ${ex.question}\nA${idx + 1}: ${ex.answer}`)
      .join('\n\n');

    const userMessage = `Summarize this session:\n\n${exchangeText}`;

    return this.generateCompletion(systemPrompt, userMessage, {
      maxTokens: 200,
      temperature: 0.7,
    });
  }

  /**
   * Test API connectivity
   */
  async testConnection(): Promise<boolean> {
    try {
      const response = await this.generateCompletion(
        'You are a helpful assistant.',
        'Say "Hello" in one word.',
        { maxTokens: 10 }
      );
      
      logger.info('Anthropic API connection test successful', { response });
      return true;
    } catch (error) {
      logger.error('Anthropic API connection test failed', { error });
      return false;
    }
  }

  /**
   * Handle errors with retry logic
   */
  private async handleError(
    error: unknown,
    retryCount: number,
    systemPrompt: string,
    userMessage: string,
    options?: {
      maxTokens?: number;
      temperature?: number;
    }
  ): Promise<string> {
    const errorMessage = error instanceof Error ? error.message : 'Unknown error';
    
    logger.error('Anthropic API error', {
      error: errorMessage,
      retryCount,
      maxRetries: this.maxRetries,
    });

    // Check if we should retry
    if (retryCount < this.maxRetries) {
      // Exponential backoff: 1s, 2s, 4s
      const backoffMs = Math.pow(2, retryCount) * 1000;
      
      logger.info('Retrying Anthropic API call', {
        retryCount: retryCount + 1,
        backoffMs,
      });

      await new Promise((resolve) => setTimeout(resolve, backoffMs));

      return this.generateCompletion(systemPrompt, userMessage, {
        ...options,
        retryCount: retryCount + 1,
      });
    }

    // Max retries exceeded
    throw new Error(`Anthropic API error after ${this.maxRetries} retries: ${errorMessage}`);
  }

  /**
   * Get current model information
   */
  getModelInfo(): { model: string; maxTokens: number } {
    return {
      model: this.model,
      maxTokens: 200000, // Claude Sonnet 4.5 context window
    };
  }
}

// Export singleton instance
export const anthropicService = new AnthropicService();

