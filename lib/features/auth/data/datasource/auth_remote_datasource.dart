

import '../../../../core/network/supabase_service.dart';
import '../models/auth_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthModel> login({
    required String email,
    required String password,
  });

  Future<void> logout();

  Future<AuthModel?> currentUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  @override
  Future<AuthModel> login({
    required String email,
    required String password,
  }) async {
    final response = await SupabaseService.auth.signInWithPassword(
      email: email,
      password: password,
    );
    print(SupabaseService.currentUser?.id);
print(SupabaseService.currentUser?.email);

    final user = response.user;

    if (user == null) {
      throw Exception("Email atau Password salah");
    }

    final profile = await SupabaseService.from("users")
        .select()
        .eq("auth_user_id", user.id)
        .single();

    return AuthModel.fromJson(profile);
  }

  @override
  Future<void> logout() async {
    await SupabaseService.signOut();
  }

  @override
  Future<AuthModel?> currentUser() async {
    final user = SupabaseService.currentUser;

    if (user == null) return null;

    final profile = await SupabaseService.from("users")
        .select()
        .eq("auth_user_id", user.id)
        .single();

    return AuthModel.fromJson(profile);
  }
}