import { ModuleContract } from '../../common/types';

export function registerMarketplaceModule(): ModuleContract {
  return {
    name: 'marketplace',
    routes: [
      '/v1/marketplace'
    ],
  };
}
