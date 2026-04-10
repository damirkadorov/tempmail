export type EnvConfig = {
  API_PORT: number;
  DATABASE_URL: string;
  REDIS_URL: string;
  JWT_ISSUER: string;
  JWT_AUDIENCE: string;
  MAIL_INGRESS_SHARED_SECRET: string;
};

export function readEnv(env: NodeJS.ProcessEnv): EnvConfig {
  const parsedPort = Number(env.API_PORT ?? 3000);

  return {
    API_PORT: Number.isFinite(parsedPort) && parsedPort > 0 ? parsedPort : 3000,
    DATABASE_URL: env.DATABASE_URL ?? '',
    REDIS_URL: env.REDIS_URL ?? '',
    JWT_ISSUER: env.JWT_ISSUER ?? '',
    JWT_AUDIENCE: env.JWT_AUDIENCE ?? '',
    MAIL_INGRESS_SHARED_SECRET: env.MAIL_INGRESS_SHARED_SECRET ?? '',
  };
}
