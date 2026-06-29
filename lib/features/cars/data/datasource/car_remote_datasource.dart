import 'package:rental_mobil/core/network/supabase_service.dart';
import '../models/car_model.dart';

abstract class CarRemoteDataSource {
  Future<List<CarModel>> getCars();
  Future<void> addCar(CarModel car);
  Future<void> updateCar(String id, CarModel car);
  Future<void> deleteCar(String id);
  Future<List<CarModel>> searchCars(String query);
}

class CarRemoteDataSourceImpl implements CarRemoteDataSource {
  @override
  Future<List<CarModel>> getCars() async {

 final response = await SupabaseService
     .from('mobil')
     .select();

 print("======= RAW =======");

 for(final e in response){

   print(
      "${e['nama_mobil']} "
      "${e['status_mobil']}"
   );

 }

 return (response as List)
      .map((e)=>CarModel.fromJson(e))
      .toList();

}

  @override
  Future<void> addCar(CarModel car) async {
    await SupabaseService.from('mobil').insert(car.toJson());
  }

  @override
  Future<void> updateCar(String id, CarModel car) async {
    await SupabaseService.from('mobil').update(car.toJson()).eq('id', id);
  }

  @override
  Future<void> deleteCar(String id) async {
    await SupabaseService.from('mobil').delete().eq('id', id);
  }

  @override
  Future<List<CarModel>> searchCars(String query) async {
    final response = await SupabaseService.from('mobil')
        .select()
        .or('nama_mobil.ilike.%$query%,plat_nomor.ilike.%$query%,tipe.ilike.%$query%');
    return (response as List).map((e) => CarModel.fromJson(e)).toList();
  }
}
