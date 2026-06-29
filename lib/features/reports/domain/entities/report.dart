class DashboardSummary {
  final int totalPelanggan;
  final int totalRental;
  final int totalMobil;
  final int mobilTersedia;
  final int mobilDisewa;
  final double totalPendapatan;

  const DashboardSummary({
    required this.totalPelanggan,
    required this.totalRental,
    required this.totalMobil,
    required this.mobilTersedia,
    required this.mobilDisewa,
    required this.totalPendapatan,
  });
}

class LaporanPendapatan {
  final String tanggalBayar;
  final String idPembayaran;
  final String namaMobil;
  final String namaPelanggan;
  final String metodePembayaran;
  final double jumlahBayar;

  const LaporanPendapatan({
    required this.tanggalBayar,
    required this.idPembayaran,
    required this.namaMobil,
    required this.namaPelanggan,
    required this.metodePembayaran,
    required this.jumlahBayar,
  });
}

class LaporanTransaksiRental {
  final String idRental;
  final String namaPelanggan;
  final String namaMobil;
  final String platNomor;
  final DateTime tanggalSewa;
  final DateTime tanggalKembali;
  final String statusRental;
  final double totalBiaya;
  final DateTime? createdAt;

  const LaporanTransaksiRental({
    required this.idRental,
    required this.namaPelanggan,
    required this.namaMobil,
    required this.platNomor,
    required this.tanggalSewa,
    required this.tanggalKembali,
    required this.statusRental,
    required this.totalBiaya,
    this.createdAt,
  });
}

class LaporanMobilPopuler {
  final String namaMobil;
  final String platNomor;
  final int totalDisewa;
  final double totalPendapatan;

  const LaporanMobilPopuler({
    required this.namaMobil,
    required this.platNomor,
    required this.totalDisewa,
    required this.totalPendapatan,
  });
}

class ViewPendapatanHarian {
  final String tanggal;
  final double total;

  const ViewPendapatanHarian({
    required this.tanggal,
    required this.total,
  });
}

class ReportData {
  final DashboardSummary summary;
  final List<LaporanPendapatan> pendapatan;
  final List<LaporanTransaksiRental> rental;
  final List<LaporanMobilPopuler> mobilPopuler;
  final List<ViewPendapatanHarian> pendapatanHarian;

  const ReportData({
    required this.summary,
    required this.pendapatan,
    required this.rental,
    required this.mobilPopuler,
    required this.pendapatanHarian,
  });
}

class LaporanServis {
  final String namaMobil;
  final String platNomor;
  final DateTime tanggalServis;
  final String jenisServis;
  final double biayaServis;
  final String statusServis;
  final String? keterangan;

  LaporanServis({
    required this.namaMobil,
    required this.platNomor,
    required this.tanggalServis,
    required this.jenisServis,
    required this.biayaServis,
    required this.statusServis,
    this.keterangan,
  });

  factory LaporanServis.fromJson(Map<String, dynamic> json) {
    return LaporanServis(
      namaMobil: json['nama_mobil']?.toString() ?? '',
      platNomor: json['plat_nomor']?.toString() ?? '',
      tanggalServis: json['tanggal_servis'] != null
          ? DateTime.parse(json['tanggal_servis'])
          : DateTime.now(),
      jenisServis: json['jenis_servis']?.toString() ?? '',
      biayaServis: (json['biaya_servis'] as num?)?.toDouble() ?? 0.0,
      statusServis: json['status_servis']?.toString() ?? 'proses',
      keterangan: json['keterangan']?.toString(),
    );
  }
}
