import 'package:rental_mobil/core/network/supabase_service.dart';
import '../models/pengembalian_model.dart';

abstract class PengembalianRemoteDataSource {
  Future<List<PengembalianModel>> getPengembalians();
  Future<void> addPengembalian(PengembalianModel pengembalian);
  Future<void> updatePengembalian(String id, PengembalianModel pengembalian);
  Future<void> deletePengembalian(String id);
  Future<List<PengembalianModel>> searchPengembalians(String query);
}

class PengembalianRemoteDataSourceImpl implements PengembalianRemoteDataSource {
  @override
  Future<List<PengembalianModel>> getPengembalians() async {
    final response = await SupabaseService.from('pengembalian')
        .select('''
          *,
          rental(
            id,
            pelanggan(nama),
            mobil(
              nama_mobil,
              plat_nomor
            )
          )
        ''')
        .order('created_at', ascending: false);
    return (response as List).map((e) => PengembalianModel.fromJson(e)).toList();
  }

  @override
  Future<void> addPengembalian(PengembalianModel pengembalian) async {
    // 1. Insert pengembalian record
    await SupabaseService.from('pengembalian').insert(pengembalian.toJson());

    // 2. Find the rental record to retrieve mobil_id
    final rentalResponse = await SupabaseService.from('rental')
        .select('mobil_id')
        .eq('id', pengembalian.rentalId)
        .single();
    final mobilId = rentalResponse['mobil_id'] as String?;

    // 3. Set the car status back to tersedia
    if (mobilId != null) {
      await SupabaseService.from('mobil')
          .update({'status_mobil': 'tersedia'})
          .eq('id', mobilId);
    }

    // 4. Set the rental status to selesai
    await SupabaseService.from('rental')
        .update({'status_rental': 'selesai'})
        .eq('id', pengembalian.rentalId);
  }

  @override
  Future<void> updatePengembalian(String id, PengembalianModel pengembalian) async {
    await SupabaseService.from('pengembalian').update({
      'tanggal_kembali': pengembalian.tanggalKembali.toIso8601String().split('T')[0],
      'denda': pengembalian.denda,
      'kondisi_mobil': pengembalian.kondisiMobil,
    }).eq('id', id);
  }

  @override
  Future<void> deletePengembalian(String id) async {
    // 1. Get the return details to know which rental it belongs to
    final returnResponse = await SupabaseService.from('pengembalian')
        .select('rental_id')
        .eq('id', id)
        .single();
    final rentalId = returnResponse['rental_id'] as String?;

    // 2. Delete the return record
    await SupabaseService.from('pengembalian').delete().eq('id', id);

    if (rentalId != null) {
      // 3. Find the rental's mobil_id
      final rentalResponse = await SupabaseService.from('rental')
          .select('mobil_id')
          .eq('id', rentalId)
          .single();
      final mobilId = rentalResponse['mobil_id'] as String?;

      if (mobilId != null) {
        // 4. Set the car status back to disewa
        await SupabaseService.from('mobil')
            .update({'status_mobil': 'disewa'})
            .eq('id', mobilId);
      }

      // 5. Set the rental status back to aktif
      await SupabaseService.from('rental')
          .update({'status_rental': 'aktif'})
          .eq('id', rentalId);
    }
  }

  @override
  Future<List<PengembalianModel>> searchPengembalians(String query) async {
    final list = await getPengembalians();
    if (query.isEmpty) return list;
    final lowercaseQuery = query.toLowerCase();
    return list.where((p) {
      return (p.namaPelanggan?.toLowerCase().contains(lowercaseQuery) ?? false) ||
          (p.namaMobil?.toLowerCase().contains(lowercaseQuery) ?? false) ||
          (p.platNomor?.toLowerCase().contains(lowercaseQuery) ?? false) ||
          p.kondisiMobil.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }
}
