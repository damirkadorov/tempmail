import { ModuleContract } from '../../common/types';

export function registerModerationModule(): ModuleContract {
  return {
    name: 'moderation',
    routes: [
      '/v1/moderation'
    ],
  };
}
