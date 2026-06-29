import 'package:flutter/material.dart';
import '../../domain/entities/pelanggan.dart';
import '../../domain/usecases/add_pelanggan.dart';
import '../../domain/usecases/delete_pelanggan.dart';
import '../../domain/usecases/get_pelanggan.dart';
import '../../domain/usecases/search_pelanggan.dart';
import '../../domain/usecases/update_pelanggan.dart';

class PelangganProvider extends ChangeNotifier {
  final GetPelanggan getPelangganUseCase;
  final AddPelanggan addPelangganUseCase;
  final UpdatePelanggan updatePelangganUseCase;
  final DeletePelanggan deletePelangganUseCase;
  final SearchPelanggan searchPelangganUseCase;

  PelangganProvider({
    required this.getPelangganUseCase,
    required this.addPelangganUseCase,
    required this.updatePelangganUseCase,
    required this.deletePelangganUseCase,
    required this.searchPelangganUseCase,
  });

  final searchController = TextEditingController();

  List<Pelanggan> _pelangganList = [];
  bool _loading = false;
  String? _error;

  List<Pelanggan> get pelangganList => _pelangganList;
  bool get loading => _loading;
  String? get error => _error;

  List<Pelanggan> get filteredPelanggan {
    if (searchController.text.isEmpty) {
      return pelangganList;
    }

    final keyword = searchController.text.toLowerCase();
    return pelangganList.where((p) {
      return p.nama.toLowerCase().contains(keyword) ||
          p.noHp.toLowerCase().contains(keyword) ||
          p.noIdentitas.toLowerCase().contains(keyword) ||
          (p.alamat?.toLowerCase().contains(keyword) ?? false);
    }).toList();
  }

  void onSearchChanged(String query) {
    notifyListeners();
  }

  Future<void> fetchPelanggan() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      _pelangganList = await getPelangganUseCase();
    } catch (e) {
      _error = e.toString();
    }

    _loading = false;
    notifyListeners();
  }

  Future<void> addPelanggan(Map<String, dynamic> data) async {
    _loading = true;
    notifyListeners();
    try {
      final p = Pelanggan(
        id: '',
        nama: data['nama'] ?? '',
        noHp: data['no_hp'] ?? '',
        alamat: data['alamat'],
        jenisIdentitas: data['jenis_identitas'] ?? 'KTP',
        noIdentitas: data['no_identitas'] ?? '',
        fotoIdentitas: data['foto_identitas'],
        createdAt: DateTime.now(),
      );
      await addPelangganUseCase(p);
      await fetchPelanggan();
    } catch (e) {
      _loading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updatePelanggan(String id, Map<String, dynamic> data) async {
    _loading = true;
    notifyListeners();
    try {
      final p = Pelanggan(
        id: id,
        nama: data['nama'] ?? '',
        noHp: data['no_hp'] ?? '',
        alamat: data['alamat'],
        jenisIdentitas: data['jenis_identitas'] ?? 'KTP',
        noIdentitas: data['no_identitas'] ?? '',
        fotoIdentitas: data['foto_identitas'],
        createdAt: DateTime.now(),
      );
      await updatePelangganUseCase(id, p);
      await fetchPelanggan();
    } catch (e) {
      _loading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> deletePelanggan(String id) async {
    _loading = true;
    notifyListeners();
    try {
      await deletePelangganUseCase(id);
      await fetchPelanggan();
    } catch (e) {
      _loading = false;
      notifyListeners();
      rethrow;
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
