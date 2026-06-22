enum AppEnvironment { development, staging, production }

class Env {
  Env._();

  static AppEnvironment environment = AppEnvironment.development;

  static bool get isDevelopment => environment == AppEnvironment.development;

  static bool get isStaging => environment == AppEnvironment.staging;

  static bool get isProduction => environment == AppEnvironment.production;
}
