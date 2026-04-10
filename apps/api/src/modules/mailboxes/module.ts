import { ModuleContract } from '../../common/types';

export function registerMailboxesModule(): ModuleContract {
  return {
    name: 'mailboxes',
    routes: [
      '/v1/mailboxes'
    ],
  };
}
