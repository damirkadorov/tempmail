import { ModuleContract } from '../../common/types';

export function registerMessagesModule(): ModuleContract {
  return {
    name: 'messages',
    routes: [
      '/v1/messages'
    ],
  };
}
