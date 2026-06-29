import 'package:rental_mobil/core/network/supabase_service.dart';
import '../models/pelanggan_model.dart';

abstract class PelangganRemoteDataSource {
  Future<List<PelangganModel>> getPelanggan();
  Future<void> addPelanggan(PelangganModel pelanggan);
  Future<void> updatePelanggan(String id, PelangganModel pelanggan);
  Future<void> deletePelanggan(String id);
  Future<List<PelangganModel>> searchPelanggan(String query);
}

class PelangganRemoteDataSourceImpl implements PelangganRemoteDataSource {
  @override
  Future<List<PelangganModel>> getPelanggan() async {
    final response = await SupabaseService.from('pelanggan')
        .select()
        .order('created_at', ascending: false);
    return (response as List).map((e) => PelangganModel.fromJson(e)).toList();
  }

  @override
  Future<void> addPelanggan(PelangganModel pelanggan) async {
    await SupabaseService.from('pelanggan').insert(pelanggan.toJson());
  }

  @override
  Future<void> updatePelanggan(String id, PelangganModel pelanggan) async {
    await SupabaseService.from('pelanggan')
        .update(pelanggan.toJson())
        .eq('id', id);
  }

  @override
  Future<void> deletePelanggan(String id) async {
    // 1. Fetch the pelanggan details to check for foto_identitas URL
    final response = await SupabaseService.from('pelanggan')
        .select('foto_identitas')
        .eq('id', id)
        .single();
    final fotoIdentitas = response['foto_identitas'] as String?;

    if (fotoIdentitas != null && fotoIdentitas.isNotEmpty) {
      try {
        final uri = Uri.parse(fotoIdentitas);
        final fileName = uri.pathSegments.last;
        await SupabaseService.client.storage.from('identitas').remove([fileName]);
      } catch (e) {
        // Ignore storage removal errors to prevent blocking record deletion
      }
    }

    // 2. Delete the DB record
    await SupabaseService.from('pelanggan').delete().eq('id', id);
  }

  @override
  Future<List<PelangganModel>> searchPelanggan(String query) async {
    final response = await SupabaseService.from('pelanggan')
        .select()
        .or('nama.ilike.%$query%,no_hp.ilike.%$query%,no_identitas.ilike.%$query%,alamat.ilike.%$query%');
    return (response as List).map((e) => PelangganModel.fromJson(e)).toList();
  }
}
