import 'package:rental_mobil/core/network/supabase_service.dart';
import '../models/service_model.dart';

abstract class ServiceRemoteDataSource {
  Future<List<ServiceModel>> getServices();
  Future<void> addService(ServiceModel service);
  Future<void> updateService(String id, ServiceModel service);
  Future<void> deleteService(String id);
  Future<List<ServiceModel>> searchServices(String query);
}

class ServiceRemoteDataSourceImpl implements ServiceRemoteDataSource {

  @override
  Future<List<ServiceModel>> getServices() async {
    final response = await SupabaseService
        .from('servis')
        .select('''
          *,
          mobil(
            nama_mobil,
            plat_nomor
          )
        ''')
        .order('created_at', ascending: false);

    return (response as List)
        .map((e) => ServiceModel.fromJson(e))
        .toList();
  }

  @override
  Future<void> addService(ServiceModel service) async {
    final carResponse = await SupabaseService
        .from('mobil')
        .select('status_mobil')
        .eq('id', service.mobilId)
        .single();

    final statusMobil = carResponse['status_mobil'] as String?;

    if (statusMobil != 'tersedia') {
      throw Exception('Mobil tidak tersedia');
    }

    await SupabaseService
        .from('servis')
        .insert(service.toJson());
  }

  @override
  Future<void> updateService(String id, ServiceModel service) async {
    await SupabaseService
        .from('servis')
        .update({
          'mobil_id': service.mobilId,
          'tanggal_servis': service.tanggalServis.toIso8601String().split('T')[0],
          'jenis_servis': service.jenisServis,
          'biaya_servis': service.biayaServis,
          'keterangan': service.keterangan,
          'status_servis': service.statusServis,
        })
        .eq('id', id);
  }

  @override
  Future<void> deleteService(String id) async {
    await SupabaseService
        .from('servis')
        .delete()
        .eq('id', id);
  }

  @override
  Future<List<ServiceModel>> searchServices(String query) async {
    final list = await getServices();

    if (query.isEmpty) return list;

    final lowercaseQuery = query.toLowerCase();

    return list.where((s) {
      return (s.namaMobil?.toLowerCase().contains(lowercaseQuery) ?? false)
          || (s.platNomor?.toLowerCase().contains(lowercaseQuery) ?? false)
          || s.jenisServis.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }
}