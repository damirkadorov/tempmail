import { startServer } from './server';
import { readEnv } from './config/env';

async function bootstrap() {
  const env = readEnv(process.env);
  await startServer(env.API_PORT);
}

void bootstrap();
