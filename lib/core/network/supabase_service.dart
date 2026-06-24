import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  SupabaseService._();

  static SupabaseClient get client => Supabase.instance.client;

  static GoTrueClient get auth => client.auth;

  static SupabaseQueryBuilder from(String table) {
    return client.from(table);
  }

  static Future<void> signOut() {
    return auth.signOut();
  }

  static User? get currentUser {
    return auth.currentUser;
  }

  static Session? get currentSession {
    return auth.currentSession;
  }
}
