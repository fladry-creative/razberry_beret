import dotenv from 'dotenv';

// Load environment variables from .env file
dotenv.config();

interface EnvConfig {
  port: number;
  nodeEnv: string;
  supabase: {
    url: string;
    anonKey: string;
    serviceKey: string;
  };
  anthropic: {
    apiKey: string;
  };
  openai: {
    apiKey: string;
  };
  session: {
    secret: string;
  };
  logging: {
    level: string;
  };
}

function getEnvVar(key: string, defaultValue?: string): string {
  const value = process.env[key] || defaultValue;
  if (!value) {
    throw new Error(`Environment variable ${key} is not set`);
  }
  return value;
}

export const config: EnvConfig = {
  port: parseInt(getEnvVar('PORT', '3000'), 10),
  nodeEnv: getEnvVar('NODE_ENV', 'development'),
  supabase: {
    url: getEnvVar('SUPABASE_URL', 'https://placeholder.supabase.co'),
    anonKey: getEnvVar('SUPABASE_ANON_KEY', 'placeholder-anon-key'),
    serviceKey: getEnvVar('SUPABASE_SERVICE_KEY', 'placeholder-service-key'),
  },
  anthropic: {
    apiKey: getEnvVar('ANTHROPIC_API_KEY', 'placeholder-anthropic-key'),
  },
  openai: {
    apiKey: getEnvVar('OPENAI_API_KEY', 'placeholder-openai-key'),
  },
  session: {
    secret: getEnvVar('SESSION_SECRET', 'placeholder-session-secret'),
  },
  logging: {
    level: getEnvVar('LOG_LEVEL', 'debug'),
  },
};

