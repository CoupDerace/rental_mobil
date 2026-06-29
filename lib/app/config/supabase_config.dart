class SupabaseConfig {
  SupabaseConfig._();

  static const String url = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://jssqlrmoqobdtwxkteby.supabase.co/',
  );

  static const String anonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Impzc3Fscm1vcW9iZHR3eGt0ZWJ5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODE4MDcxMzIsImV4cCI6MjA5NzM4MzEzMn0.1Jro9gly5tVpOjRhQe5JK7ebmJZ79sGn-RywfUSRG0c',
  );

  static bool get isConfigured => url.isNotEmpty && anonKey.isNotEmpty;
}
