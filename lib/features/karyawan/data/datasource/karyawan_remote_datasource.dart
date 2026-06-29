import 'package:flutter/foundation.dart';
import 'package:rental_mobil/core/network/supabase_service.dart';
import '../models/karyawan_model.dart';

abstract class KaryawanRemoteDataSource {
  Future<List<KaryawanModel>> getKaryawan();
  Future<void> addKaryawan(KaryawanModel karyawan);
  Future<void> updateKaryawan(KaryawanModel karyawan);
  Future<void> deleteKaryawan(String id);
  Future<List<KaryawanModel>> searchKaryawan(String keyword);
}

class KaryawanRemoteDataSourceImpl implements KaryawanRemoteDataSource {
  @override
  Future<List<KaryawanModel>> getKaryawan() async {
    debugPrint("[DEBUG DS] getKaryawan() called");
    try {
      final response = await SupabaseService.from('karyawan')
          .select()
          .order('created_at', ascending: false);
      debugPrint("[DEBUG DS] getKaryawan response type: ${response.runtimeType}");
      debugPrint("[DEBUG DS] getKaryawan raw response: $response");
      final list = (response as List).map((e) => KaryawanModel.fromJson(e)).toList();
      debugPrint("[DEBUG DS] getKaryawan mapped list count: ${list.length}");
      return list;
    } catch (e, stack) {
      debugPrint("[DEBUG DS] getKaryawan ERROR: $e");
      debugPrint(stack.toString());
      rethrow;
    }
  }

  @override
  Future<void> addKaryawan(KaryawanModel karyawan) async {
    debugPrint("[DEBUG DS] addKaryawan() called with: ${karyawan.toJson()}");
    try {
      await SupabaseService.from('karyawan').insert(karyawan.toJson());
      debugPrint("[DEBUG DS] addKaryawan SUCCESS");
    } catch (e) {
      debugPrint("[DEBUG DS] addKaryawan ERROR: $e");
      rethrow;
    }
  }

  @override
  Future<void> updateKaryawan(KaryawanModel karyawan) async {
    debugPrint("[DEBUG DS] updateKaryawan() called for ID: ${karyawan.id} with: ${karyawan.toJson()}");
    try {
      await SupabaseService.from('karyawan')
          .update(karyawan.toJson())
          .eq('id', karyawan.id);
      debugPrint("[DEBUG DS] updateKaryawan SUCCESS");
    } catch (e) {
      debugPrint("[DEBUG DS] updateKaryawan ERROR: $e");
      rethrow;
    }
  }

  @override
  Future<void> deleteKaryawan(String id) async {
    debugPrint("[DEBUG DS] deleteKaryawan() called for ID: $id");
    try {
      await SupabaseService.from('karyawan').delete().eq('id', id);
      debugPrint("[DEBUG DS] deleteKaryawan SUCCESS");
    } catch (e) {
      debugPrint("[DEBUG DS] deleteKaryawan ERROR: $e");
      rethrow;
    }
  }

  @override
  Future<List<KaryawanModel>> searchKaryawan(String keyword) async {
    debugPrint("[DEBUG DS] searchKaryawan() called with keyword: $keyword");
    try {
      final response = await SupabaseService.from('karyawan')
          .select()
          .or('nama_karyawan.ilike.%$keyword%,jabatan.ilike.%$keyword%,no_hp.ilike.%$keyword%')
          .order('created_at', ascending: false);
      debugPrint("[DEBUG DS] searchKaryawan raw response: $response");
      final list = (response as List).map((e) => KaryawanModel.fromJson(e)).toList();
      debugPrint("[DEBUG DS] searchKaryawan mapped list count: ${list.length}");
      return list;
    } catch (e) {
      debugPrint("[DEBUG DS] searchKaryawan ERROR: $e");
      rethrow;
    }
  }
}
