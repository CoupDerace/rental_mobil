import 'package:flutter/foundation.dart';
import 'package:rental_mobil/core/network/supabase_service.dart';
import '../models/user_model.dart';

abstract class UserRemoteDataSource {
  Future<List<UserModel>> getUsers();
  Future<void> addUser(UserModel user);
  Future<void> updateUser(String id, UserModel user);
  Future<void> deleteUser(String id);
  Future<List<UserModel>> searchUsers(String query);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  @override
  Future<List<UserModel>> getUsers() async {
    debugPrint("[DEBUG USER DS] getUsers() called");
    try {
      final response = await SupabaseService.from('users')
          .select()
          .order('created_at', ascending: false);
      debugPrint("[DEBUG USER DS] getUsers response type: ${response.runtimeType}");
      debugPrint("[DEBUG USER DS] getUsers raw response: $response");
      final list = (response as List).map((e) => UserModel.fromJson(e)).toList();
      debugPrint("[DEBUG USER DS] getUsers mapped list count: ${list.length}");
      return list;
    } catch (e, stack) {
      debugPrint("[DEBUG USER DS] getUsers ERROR: $e");
      debugPrint(stack.toString());
      rethrow;
    }
  }

  @override
  Future<void> addUser(UserModel user) async {
    debugPrint("[DEBUG USER DS] addUser() called with: ${user.toJson()}");
    try {
      await SupabaseService.from('users').insert(user.toJson());
      debugPrint("[DEBUG USER DS] addUser SUCCESS");
    } catch (e) {
      debugPrint("[DEBUG USER DS] addUser ERROR: $e");
      rethrow;
    }
  }

  @override
  Future<void> updateUser(String id, UserModel user) async {
    debugPrint("[DEBUG USER DS] updateUser() called for ID: $id with: ${user.toJson()}");
    try {
      await SupabaseService.from('users').update(user.toJson()).eq('id', id);
      debugPrint("[DEBUG USER DS] updateUser SUCCESS");
    } catch (e) {
      debugPrint("[DEBUG USER DS] updateUser ERROR: $e");
      rethrow;
    }
  }

  @override
  Future<void> deleteUser(String id) async {
    debugPrint("[DEBUG USER DS] deleteUser() called for ID: $id");
    try {
      await SupabaseService.from('users').delete().eq('id', id);
      debugPrint("[DEBUG USER DS] deleteUser SUCCESS");
    } catch (e) {
      debugPrint("[DEBUG USER DS] deleteUser ERROR: $e");
      rethrow;
    }
  }

  @override
  Future<List<UserModel>> searchUsers(String query) async {
    debugPrint("[DEBUG USER DS] searchUsers() called with query: $query");
    try {
      final list = await getUsers();
      if (query.isEmpty) return list;
      final lowercaseQuery = query.toLowerCase();
      final filtered = list.where((u) {
        return u.nama.toLowerCase().contains(lowercaseQuery) ||
            u.email.toLowerCase().contains(lowercaseQuery) ||
            u.role.toLowerCase().contains(lowercaseQuery);
      }).toList();
      debugPrint("[DEBUG USER DS] searchUsers filtered count: ${filtered.length}");
      return filtered;
    } catch (e) {
      debugPrint("[DEBUG USER DS] searchUsers ERROR: $e");
      rethrow;
    }
  }
}
