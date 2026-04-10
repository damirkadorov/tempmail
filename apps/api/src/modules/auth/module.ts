import { ModuleContract } from '../../common/types';

export function registerAuthModule(): ModuleContract {
  return {
    name: 'auth',
    routes: [
      '/v1/auth'
    ],
  };
}
