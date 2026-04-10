import { createServer, IncomingMessage, ServerResponse } from 'node:http';
import { createApp } from './app';

export function handleApiRequest(_req: IncomingMessage, res: ServerResponse) {
  const app = createApp();
  res.setHeader('content-type', 'application/json; charset=utf-8');
  res.statusCode = 200;
  res.end(JSON.stringify(app));
}

export function startServer(port: number) {
  const server = createServer((req, res) => handleApiRequest(req, res));
  return new Promise<void>((resolve) => {
    server.listen(port, () => resolve());
  });
}
