# Razberry Beret Backend

Backend API for Razberry Beret - The Corpus Defense System for Founders.

## Tech Stack

- **Node.js 20+** - JavaScript runtime
- **Express.js** - Web framework
- **TypeScript** - Type-safe JavaScript
- **Supabase** - Backend as a Service (Auth + PostgreSQL)
- **Winston** - Logging
- **Helmet** - Security headers
- **Morgan** - HTTP request logging

## Getting Started

### Prerequisites

- Node.js 20 or higher
- npm 9 or higher
- Supabase account (optional for initial testing)

### Installation

1. Install dependencies:
   ```bash
   npm install
   ```

2. Create `.env` file from example:
   ```bash
   cp .env.example .env
   ```

3. Update `.env` with your configuration (optional for testing):
   ```env
   PORT=3000
   NODE_ENV=development
   SUPABASE_URL=your-supabase-url
   SUPABASE_ANON_KEY=your-anon-key
   SUPABASE_SERVICE_KEY=your-service-key
   ```

### Running the Server

#### Development Mode (with auto-reload)
```bash
npm run dev
```

#### Production Build
```bash
npm run build
npm start
```

### Available Scripts

- `npm run dev` - Start development server with auto-reload
- `npm run build` - Build TypeScript to JavaScript
- `npm start` - Start production server
- `npm run lint` - Run ESLint
- `npm run format` - Format code with Prettier
- `npm run type-check` - Type check without emitting files

## Project Structure

```
backend/
├── src/
│   ├── config/          # Configuration files
│   │   ├── env.ts       # Environment variables
│   │   ├── logger.ts    # Winston logger setup
│   │   └── supabase.ts  # Supabase client
│   ├── middleware/      # Express middleware
│   │   └── errorHandler.ts
│   ├── routes/          # API routes
│   │   └── health.ts    # Health check endpoint
│   ├── app.ts           # Express app setup
│   └── index.ts         # Server entry point
├── dist/                # Compiled JavaScript (generated)
├── .env.example         # Example environment variables
├── package.json
├── tsconfig.json
└── README.md
```

## API Endpoints

### Health Check

**GET** `/health`

Returns server health status and service connectivity.

**Response:**
```json
{
  "success": true,
  "data": {
    "status": "ok",
    "timestamp": "2025-10-13T12:00:00.000Z",
    "uptime": 123.456,
    "environment": "development",
    "services": {
      "supabase": "connected"
    }
  }
}
```

## Environment Variables

| Variable | Description | Required | Default |
|----------|-------------|----------|---------|
| `PORT` | Server port | No | `3000` |
| `NODE_ENV` | Environment (development/production) | No | `development` |
| `SUPABASE_URL` | Supabase project URL | Yes* | - |
| `SUPABASE_ANON_KEY` | Supabase anonymous key | Yes* | - |
| `SUPABASE_SERVICE_KEY` | Supabase service role key | Yes* | - |
| `ANTHROPIC_API_KEY` | Anthropic API key for Claude | Yes* | - |
| `OPENAI_API_KEY` | OpenAI API key for Whisper | Yes* | - |
| `SESSION_SECRET` | Session secret for cookies | Yes* | - |
| `LOG_LEVEL` | Winston log level | No | `debug` |

\* Will be required in later phases when features are implemented

## Development

### Code Style

- Follow TypeScript best practices
- Use async/await over promises
- Always handle errors properly
- Write descriptive variable names
- Add JSDoc comments for public APIs

### Error Handling

Use the `APIError` class for throwing HTTP errors:

```typescript
import { APIError } from './middleware/errorHandler';

throw new APIError('User not found', 404);
```

### Logging

Use the Winston logger:

```typescript
import { logger } from './config/logger';

logger.info('User created', { userId: user.id });
logger.error('Failed to create user', { error });
```

## Testing

Coming soon in Phase 6.

## Deployment

Deployment instructions will be added in later phases.

## Contributing

See [CONTRIBUTING.md](../CONTRIBUTING.md) in the root directory.

## License

[License TBD]

