import { WorkerJob } from '../queue';

export const notificationDispatchWorker: WorkerJob = {
  name: 'notification-dispatch',
  queue: 'notification-dispatch',
  maxConcurrency: 10,
};
