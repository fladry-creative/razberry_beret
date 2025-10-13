#!/usr/bin/env tsx

/**
 * Test script for Anthropic API integration
 * 
 * Usage: npm run test:anthropic
 * or: tsx src/scripts/test-anthropic.ts
 */

import { anthropicService } from '../services/anthropic.service';
import { logger } from '../config/logger';

async function testAnthropicIntegration() {
  logger.info('=== Testing Anthropic API Integration ===');

  try {
    // Test 1: Basic connectivity
    logger.info('Test 1: Testing API connectivity...');
    const isConnected = await anthropicService.testConnection();
    
    if (!isConnected) {
      logger.error('❌ API connectivity test failed');
      process.exit(1);
    }
    
    logger.info('✅ API connectivity test passed');

    // Test 2: Generate a question
    logger.info('Test 2: Generating a question...');
    const question = await anthropicService.generateQuestion();
    
    logger.info('✅ Question generated successfully', { question });

    // Test 3: Generate a question with context
    logger.info('Test 3: Generating follow-up question...');
    const followUpQuestion = await anthropicService.generateQuestion(
      'We are building an AI-powered tool to help founders preserve their authentic brand voice.',
      'Second question in session'
    );
    
    logger.info('✅ Follow-up question generated', { followUpQuestion });

    // Test 4: Generate session recap
    logger.info('Test 4: Generating session recap...');
    const recap = await anthropicService.generateSessionRecap([
      {
        question: 'What problem does your company solve?',
        answer: 'We help founders avoid AI drift by capturing their authentic voice through structured conversations.',
      },
      {
        question: 'Why is this important?',
        answer: 'Because AI tools trained on consensus data push everyone toward the same generic solutions.',
      },
    ]);
    
    logger.info('✅ Session recap generated', { recap });

    // Test 5: Model information
    logger.info('Test 5: Checking model information...');
    const modelInfo = anthropicService.getModelInfo();
    
    logger.info('✅ Model information retrieved', modelInfo);

    logger.info('=== All tests passed! ===');
    process.exit(0);
  } catch (error) {
    logger.error('❌ Test failed', { error });
    process.exit(1);
  }
}

// Run tests
testAnthropicIntegration();

