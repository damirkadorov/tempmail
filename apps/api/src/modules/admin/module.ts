import { ModuleContract } from '../../common/types';

export function registerAdminModule(): ModuleContract {
  return {
    name: 'admin',
    routes: [
      '/v1/admin'
    ],
  };
}
