import { ModuleContract } from '../../common/types';

export function registerDomainsModule(): ModuleContract {
  return {
    name: 'domains',
    routes: [
      '/v1/domains'
    ],
  };
}
