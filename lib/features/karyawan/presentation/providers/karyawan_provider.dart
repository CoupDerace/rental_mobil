import 'package:flutter/material.dart';
import '../../domain/entities/karyawan.dart';
import '../../domain/usecases/get_karyawan.dart';
import '../../domain/usecases/add_karyawan.dart';
import '../../domain/usecases/update_karyawan.dart';
import '../../domain/usecases/delete_karyawan.dart';
import '../../domain/usecases/search_karyawan.dart';

class KaryawanProvider extends ChangeNotifier {
  final GetKaryawan getKaryawanUseCase;
  final AddKaryawan addKaryawanUseCase;
  final UpdateKaryawan updateKaryawanUseCase;
  final DeleteKaryawan deleteKaryawanUseCase;
  final SearchKaryawan searchKaryawanUseCase;

  KaryawanProvider({
    required this.getKaryawanUseCase,
    required this.addKaryawanUseCase,
    required this.updateKaryawanUseCase,
    required this.deleteKaryawanUseCase,
    required this.searchKaryawanUseCase,
  });

  final searchController = TextEditingController();

  List<KaryawanEntity> _karyawanList = [];
  bool _loading = false;
  String? _error;

  List<KaryawanEntity> get karyawanList => _karyawanList;
  bool get loading => _loading;
  String? get error => _error;

  List<KaryawanEntity> get filteredKaryawan {
    if (searchController.text.isEmpty) return _karyawanList;
    final keyword = searchController.text.toLowerCase();
    return _karyawanList.where((k) {
      return k.namaKaryawan.toLowerCase().contains(keyword) ||
          k.jabatan.toLowerCase().contains(keyword) ||
          k.noHp.toLowerCase().contains(keyword);
    }).toList();
  }

  void onSearchChanged(String query) {
    notifyListeners();
  }

  Future<void> fetchKaryawan() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _karyawanList = await getKaryawanUseCase();
      debugPrint("Karyawan List Loaded: ${_karyawanList.length} items");
    } catch (e, stack) {
      _error = e.toString();
      debugPrint("Karyawan List Load Error: $e");
      debugPrint(stack.toString());
    }
    _loading = false;
    notifyListeners();
  }

  Future<void> addKaryawan(KaryawanEntity karyawan) async {
    _loading = true;
    notifyListeners();
    try {
      await addKaryawanUseCase(karyawan);
      await fetchKaryawan();
    } catch (e) {
      _error = e.toString();
      _loading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updateKaryawan(KaryawanEntity karyawan) async {
    _loading = true;
    notifyListeners();
    try {
      await updateKaryawanUseCase(karyawan);
      await fetchKaryawan();
    } catch (e) {
      _error = e.toString();
      _loading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> deleteKaryawan(String id) async {
    _loading = true;
    notifyListeners();
    try {
      await deleteKaryawanUseCase(id);
      await fetchKaryawan();
    } catch (e) {
      _error = e.toString();
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
