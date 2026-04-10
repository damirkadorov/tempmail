import { mailboxExpirationWorker } from './workers/mailbox-expiration.worker';
import { rentalExpirationWorker } from './workers/rental-expiration.worker';
import { retryJobsWorker } from './workers/retry-jobs.worker';
import { notificationDispatchWorker } from './workers/notification-dispatch.worker';
import { abuseScanningWorker } from './workers/abuse-scanning.worker';

export function startWorkers() {
  return [
    mailboxExpirationWorker,
    rentalExpirationWorker,
    retryJobsWorker,
    notificationDispatchWorker,
    abuseScanningWorker,
  ];
}
