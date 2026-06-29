import 'package:rental_mobil/core/network/supabase_service.dart';
import '../models/rental_model.dart';

abstract class RentalRemoteDataSource {
  Future<List<RentalModel>> getRentals();
  Future<void> addRental(RentalModel rental);
  Future<void> updateRental(String id, RentalModel rental);
  Future<void> deleteRental(String id);
  Future<List<RentalModel>> searchRentals(String query);
}

class RentalRemoteDataSourceImpl implements RentalRemoteDataSource {
  @override
  Future<List<RentalModel>> getRentals() async {
    final response = await SupabaseService.from('rental')
        .select('''
          *,
          pelanggan(nama),
          mobil(nama_mobil,plat_nomor,harga_sewa_perhari)
        ''')
        .order('created_at', ascending: false);
    return (response as List).map((e) => RentalModel.fromJson(e)).toList();
  }

  @override
  Future<void> addRental(RentalModel rental) async {
    // 1. Verify mobil.status_mobil == 'tersedia'
    final carResponse = await SupabaseService.from('mobil')
        .select('status_mobil')
        .eq('id', rental.mobilId)
        .single();
    final statusMobil = carResponse['status_mobil'] as String?;
    if (statusMobil != 'tersedia') {
      throw Exception('Mobil tidak tersedia');
    }

    // 2. Insert rental
    await SupabaseService.from('rental').insert(rental.toJson());

    // 3. Update mobil.status_mobil = 'disewa'
    await SupabaseService.from('mobil')
        .update({'status_mobil': 'disewa'})
        .eq('id', rental.mobilId);
  }

  @override
  Future<void> updateRental(String id, RentalModel rental) async {
    // 1. Fetch old rental record to check if mobil_id has changed
    final oldRentalResponse = await SupabaseService.from('rental')
        .select('mobil_id')
        .eq('id', id)
        .single();
    final oldMobilId = oldRentalResponse['mobil_id'] as String?;

    if (oldMobilId != rental.mobilId) {
      // Car changed! Verify new car is tersedia
      final newCarResponse = await SupabaseService.from('mobil')
          .select('status_mobil')
          .eq('id', rental.mobilId)
          .single();
      final statusMobil = newCarResponse['status_mobil'] as String?;
      if (statusMobil != 'tersedia') {
        throw Exception('Mobil tidak tersedia');
      }

      // Update old car back to tersedia
      if (oldMobilId != null) {
        await SupabaseService.from('mobil')
            .update({'status_mobil': 'tersedia'})
            .eq('id', oldMobilId);
      }

      // Update new car to disewa
      await SupabaseService.from('mobil')
          .update({'status_mobil': 'disewa'})
          .eq('id', rental.mobilId);
    }

    // 2. Update rental
    await SupabaseService.from('rental').update(rental.toJson()).eq('id', id);
  }

  @override
  Future<void> deleteRental(String id) async {
    await SupabaseService.from('rental').delete().eq('id', id);
  }

  @override
  Future<List<RentalModel>> searchRentals(String query) async {
    final list = await getRentals();
    if (query.isEmpty) return list;
    final lowercaseQuery = query.toLowerCase();
    return list.where((item) {
      final customerMatch = item.namaPelanggan?.toLowerCase().contains(lowercaseQuery) ?? false;
      final carMatch = item.namaMobil?.toLowerCase().contains(lowercaseQuery) ?? false;
      final plateMatch = item.platNomor?.toLowerCase().contains(lowercaseQuery) ?? false;
      final statusMatch = item.statusRental.toLowerCase().contains(lowercaseQuery);
      return customerMatch || carMatch || plateMatch || statusMatch;
    }).toList();
  }
}
