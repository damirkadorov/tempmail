import type { IncomingMessage, ServerResponse } from 'node:http';
import { handleApiRequest } from '../apps/api/src/server';

export default function handler(req: IncomingMessage, res: ServerResponse) {
  handleApiRequest(req, res);
}
