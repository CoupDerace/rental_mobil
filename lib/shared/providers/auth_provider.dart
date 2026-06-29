import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/network/supabase_service.dart';

class AuthProvider extends ChangeNotifier {
  User? _user;

  Map<String, dynamic>? _profile;

  bool _loading = false;

  bool get loading => _loading;

  User? get user => _user;

  Map<String, dynamic>? get profile => _profile;

  bool get isAuthenticated => _user != null;

  String get role => _profile?['role'] ?? '';

  Future<void> loadSession() async {
    _loading = true;
    notifyListeners();

    try {
      _user = SupabaseService.currentUser;
      print("CURRENT USER = ${_user?.id}");

      if (_user != null) {
        final data = await SupabaseService.from("users")
            .select()
            .eq("auth_user_id", _user!.id)
            .maybeSingle();

        print("PROFILE = $data");
        _profile = data;
      }
    } catch (e) {
      print("Error loading session: $e");
      _user = null;
      _profile = null;
    }

    _loading = false;
    notifyListeners();
  }

  Future<void> logout() async {
    await SupabaseService.signOut();

    _user = null;
    _profile = null;

    notifyListeners();
  }
}