export type EnvConfig = {
  DATABASE_URL: string;
  REDIS_URL: string;
  JWT_ISSUER: string;
  JWT_AUDIENCE: string;
  MAIL_INGRESS_SHARED_SECRET: string;
};

export function readEnv(env: NodeJS.ProcessEnv): EnvConfig {
  return {
    DATABASE_URL: env.DATABASE_URL ?? '',
    REDIS_URL: env.REDIS_URL ?? '',
    JWT_ISSUER: env.JWT_ISSUER ?? '',
    JWT_AUDIENCE: env.JWT_AUDIENCE ?? '',
    MAIL_INGRESS_SHARED_SECRET: env.MAIL_INGRESS_SHARED_SECRET ?? '',
  };
}
