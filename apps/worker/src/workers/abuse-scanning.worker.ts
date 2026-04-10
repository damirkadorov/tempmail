import { WorkerJob } from '../queue';

export const abuseScanningWorker: WorkerJob = {
  name: 'abuse-scanning',
  queue: 'abuse-scanning',
  maxConcurrency: 4,
};
