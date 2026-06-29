import '../entities/pengembalian.dart';

abstract class PengembalianRepository {
  Future<List<Pengembalian>> getPengembalians();
  Future<void> addPengembalian(Pengembalian pengembalian);
  Future<void> updatePengembalian(String id, Pengembalian pengembalian);
  Future<void> deletePengembalian(String id);
  Future<List<Pengembalian>> searchPengembalians(String query);
}
