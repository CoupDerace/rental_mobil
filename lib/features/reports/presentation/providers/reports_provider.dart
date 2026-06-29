import 'package:flutter/material.dart';
import '../../../../core/network/supabase_service.dart';
import '../../../cars/domain/entities/car.dart';
import '../../../cars/domain/usecases/get_car.dart';
import '../../../pelanggan/domain/entities/pelanggan.dart';
import '../../../pelanggan/domain/usecases/get_pelanggan.dart';
import '../../../services/domain/usecases/get_services.dart';
import '../../domain/entities/report.dart';
import '../../domain/usecases/get_reports.dart';

class ReportsProvider extends ChangeNotifier {
  final GetReports getReportsUseCase;
  final GetCars getCarsUseCase;
  final GetPelanggan getPelangganUseCase;
  final GetServices getServicesUseCase;

  ReportsProvider({
    required this.getReportsUseCase,
    required this.getCarsUseCase,
    required this.getPelangganUseCase,
    required this.getServicesUseCase,
  });

  final pendapatanSearchController = TextEditingController();
  final rentalSearchController = TextEditingController();
  final servisSearchController = TextEditingController();

  DateTime _dariTanggal = DateTime.now().subtract(const Duration(days: 30));
  DateTime _sampaiTanggal = DateTime.now();

  DateTime get dariTanggal => _dariTanggal;
  DateTime get sampaiTanggal => _sampaiTanggal;

  ReportData? _reportData;
  List<Car> _cars = [];
  List<Pelanggan> _pelanggan = [];
  List<LaporanServis> _servisList = [];

  bool _loading = false;
  String? _error;

  ReportData? get reportData => _reportData;
  List<Car> get cars => _cars;
  List<Pelanggan> get pelanggan => _pelanggan;
  List<LaporanServis> get servisList => _servisList;
  bool get loading => _loading;
  String? get error => _error;

  // Set date ranges
  void setDariTanggal(DateTime val) {
    _dariTanggal = val;
    notifyListeners();
  }

  void setSampaiTanggal(DateTime val) {
    _sampaiTanggal = val;
    notifyListeners();
  }

  void onSearchChanged(String query) {
    notifyListeners();
  }

  // Filtered Pendapatan List
  List<LaporanPendapatan> get filteredPendapatan {
    final raw = _reportData?.pendapatan ?? [];
    
    // Search filter
    final search = pendapatanSearchController.text.toLowerCase();
    return raw.where((item) {
      final matchesSearch = item.namaPelanggan.toLowerCase().contains(search) ||
          item.namaMobil.toLowerCase().contains(search) ||
          item.metodePembayaran.toLowerCase().contains(search);
      return matchesSearch;
    }).toList();
  }

  // Filtered Rental List
  List<LaporanTransaksiRental> get filteredRental {
    final raw = _reportData?.rental ?? [];

    // Search filter
    final search = rentalSearchController.text.toLowerCase();
    return raw.where((item) {
      final matchesSearch = item.namaPelanggan.toLowerCase().contains(search) ||
          item.namaMobil.toLowerCase().contains(search) ||
          item.platNomor.toLowerCase().contains(search) ||
          item.statusRental.toLowerCase().contains(search);
      return matchesSearch;
    }).toList();
  }

  // Filtered Servis List
  List<LaporanServis> get filteredServis {
    final search = servisSearchController.text.toLowerCase();
    
    final list = _servisList.where((item) {
      final matchesSearch = item.namaMobil.toLowerCase().contains(search) ||
          item.platNomor.toLowerCase().contains(search) ||
          item.jenisServis.toLowerCase().contains(search);

      final start = DateTime(dariTanggal.year, dariTanggal.month, dariTanggal.day);
      final end = DateTime(sampaiTanggal.year, sampaiTanggal.month, sampaiTanggal.day, 23, 59, 59);
      final date = item.tanggalServis;
      final matchesDate = date.isAfter(start.subtract(const Duration(seconds: 1))) &&
          date.isBefore(end.add(const Duration(seconds: 1)));

      return matchesSearch && matchesDate;
    }).toList();

    list.sort((a, b) => b.tanggalServis.compareTo(a.tanggalServis));
    return list;
  }

  double get totalBiayaServis {
    return filteredServis.fold(
      0.0,
      (sum, item) => sum + item.biayaServis,
    );
  }

  int get jumlahServis => filteredServis.length;

  int get jumlahServisProses {
    return filteredServis
        .where((s) => s.statusServis.toLowerCase() == 'proses')
        .length;
  }

  int get jumlahServisSelesai {
    return filteredServis
        .where((s) => s.statusServis.toLowerCase() == 'selesai')
        .length;
  }

  Future<void> fetchReportData() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      _reportData = await getReportsUseCase();
      _cars = await getCarsUseCase();
      _pelanggan = await getPelangganUseCase();
      
      // Keep executing dependency just to satisfy call
      await getServicesUseCase();

      // Read from DB view
      final servisResponse = await SupabaseService.from('laporan_servis').select();
      _servisList = (servisResponse as List).map((e) => LaporanServis.fromJson(e)).toList();
    } catch (e) {
      _error = e.toString();
    }

    _loading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    pendapatanSearchController.dispose();
    rentalSearchController.dispose();
    servisSearchController.dispose();
    super.dispose();
  }
}
