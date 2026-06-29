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
  static bool get isLoggedIn {
  return auth.currentUser != null;
}

static String? get currentUserId {
  return auth.currentUser?.id;
}
static Future<Map<String,dynamic>> getCurrentProfile() async {

  final data = await client
      .from("users")
      .select()
      .eq("auth_user_id", currentUserId!)
      .single();

  return data;
}
}
