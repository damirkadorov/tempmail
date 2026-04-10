import { ModuleContract } from '../../common/types';

export function registerWalletsModule(): ModuleContract {
  return {
    name: 'wallets',
    routes: [
      '/v1/wallets'
    ],
  };
}
