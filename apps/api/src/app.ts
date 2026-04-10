import { registerAuthModule } from './modules/auth/module';
import { registerDomainsModule } from './modules/domains/module';
import { registerMarketplaceModule } from './modules/marketplace/module';
import { registerMailboxesModule } from './modules/mailboxes/module';
import { registerMessagesModule } from './modules/messages/module';
import { registerWalletsModule } from './modules/wallets/module';
import { registerModerationModule } from './modules/moderation/module';
import { registerAdminModule } from './modules/admin/module';

export type AppModule = { name: string; routes: string[] };

export function createApp() {
  const modules: AppModule[] = [
    registerAuthModule(),
    registerDomainsModule(),
    registerMarketplaceModule(),
    registerMailboxesModule(),
    registerMessagesModule(),
    registerWalletsModule(),
    registerModerationModule(),
    registerAdminModule(),
  ];

  return {
    name: 'tempmail-api',
    modules,
  };
}
