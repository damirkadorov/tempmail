import { WorkerJob } from '../queue';

export const rentalExpirationWorker: WorkerJob = {
  name: 'rental-expiration',
  queue: 'rental-expiration',
  maxConcurrency: 5,
};
