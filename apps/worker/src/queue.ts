export type WorkerJob = {
  name: string;
  queue: string;
  maxConcurrency: number;
};
