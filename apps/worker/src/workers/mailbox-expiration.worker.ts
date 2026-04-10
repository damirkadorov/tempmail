import { WorkerJob } from '../queue';

export const mailboxExpirationWorker: WorkerJob = {
  name: 'mailbox-expiration',
  queue: 'mailbox-expiration',
  maxConcurrency: 5,
};
