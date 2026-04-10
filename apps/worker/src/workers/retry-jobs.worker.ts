import { WorkerJob } from '../queue';

export const retryJobsWorker: WorkerJob = {
  name: 'retry-jobs',
  queue: 'retry-jobs',
  maxConcurrency: 2,
};
