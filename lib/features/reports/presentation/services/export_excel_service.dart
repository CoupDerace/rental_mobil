import 'dart:io';
import 'package:excel/excel.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import '../../../cars/domain/entities/car.dart';
import '../../../pelanggan/domain/entities/pelanggan.dart';
import '../../../pengembalian/domain/entities/pengembalian.dart';
import '../../domain/entities/report.dart';

class ExportExcelService {
  Future<String> exportPendapatan({
    required List<LaporanPendapatan> data,
    required DateTime dari,
    required DateTime sampai,
  }) async {
    final excel = Excel.createExcel();
    final Sheet sheet = excel[excel.getDefaultSheet()!];

    sheet.appendRow([
      TextCellValue("Tanggal Bayar"),
      TextCellValue("ID Pembayaran"),
      TextCellValue("Nama Mobil"),
      TextCellValue("Nama Pelanggan"),
      TextCellValue("Metode Pembayaran"),
      TextCellValue("Jumlah Bayar"),
    ]);

    final displayFmt = DateFormat('dd/MM/yyyy');
    final filtered = data.where((item) {
      try {
        // tanggalBayar is already formatted as dd/MM/yyyy by the model
        final date = displayFmt.parse(item.tanggalBayar);
        return date.isAfter(dari.subtract(const Duration(days: 1))) &&
            date.isBefore(sampai.add(const Duration(days: 1)));
      } catch (_) {
        return true;
      }
    }).toList();

    for (var item in filtered) {
      sheet.appendRow([
        TextCellValue(item.tanggalBayar),
        TextCellValue(item.idPembayaran),
        TextCellValue(item.namaMobil),
        TextCellValue(item.namaPelanggan),
        TextCellValue(item.metodePembayaran),
        DoubleCellValue(item.jumlahBayar),
      ]);
    }

    final bytes = excel.save();
    final dir = await getApplicationDocumentsDirectory();
    final file = File("${dir.path}/Laporan_Pendapatan_${DateTime.now().millisecondsSinceEpoch}.xlsx");
    if (bytes != null) {
      await file.writeAsBytes(bytes);
    }
    return file.path;
  }

  Future<String> exportRental({
    required List<LaporanTransaksiRental> data,
    required DateTime dari,
    required DateTime sampai,
  }) async {
    final excel = Excel.createExcel();
    final Sheet sheet = excel[excel.getDefaultSheet()!];

    sheet.appendRow([
      TextCellValue("ID Rental"),
      TextCellValue("Nama Pelanggan"),
      TextCellValue("Nama Mobil"),
      TextCellValue("Plat Nomor"),
      TextCellValue("Tanggal Sewa"),
      TextCellValue("Tanggal Kembali"),
      TextCellValue("Status Rental"),
      TextCellValue("Total Biaya"),
    ]);

    final filtered = data.where((item) {
      return item.tanggalSewa.isAfter(dari.subtract(const Duration(days: 1))) &&
          item.tanggalSewa.isBefore(sampai.add(const Duration(days: 1)));
    }).toList();

    for (var item in filtered) {
      sheet.appendRow([
        TextCellValue(item.idRental),
        TextCellValue(item.namaPelanggan),
        TextCellValue(item.namaMobil),
        TextCellValue(item.platNomor),
        TextCellValue(item.tanggalSewa.toIso8601String().split('T')[0]),
        TextCellValue(item.tanggalKembali.toIso8601String().split('T')[0]),
        TextCellValue(item.statusRental),
        DoubleCellValue(item.totalBiaya),
      ]);
    }

    final bytes = excel.save();
    final dir = await getApplicationDocumentsDirectory();
    final file = File("${dir.path}/Laporan_Rental_${DateTime.now().millisecondsSinceEpoch}.xlsx");
    if (bytes != null) {
      await file.writeAsBytes(bytes);
    }
    return file.path;
  }

  Future<String> exportArmada(List<Car> data) async {
    final excel = Excel.createExcel();
    final Sheet sheet = excel[excel.getDefaultSheet()!];

    sheet.appendRow([
      TextCellValue("Nama Mobil"),
      TextCellValue("Plat Nomor"),
      TextCellValue("Harga Sewa Per Hari"),
      TextCellValue("Status Mobil"),
    ]);

    for (var item in data) {
      sheet.appendRow([
        TextCellValue(item.namaMobil),
        TextCellValue(item.platNomor),
        DoubleCellValue(item.hargaSewaPerhari),
        TextCellValue(item.statusMobil),
      ]);
    }

    final bytes = excel.save();
    final dir = await getApplicationDocumentsDirectory();
    final file = File("${dir.path}/Laporan_Armada_${DateTime.now().millisecondsSinceEpoch}.xlsx");
    if (bytes != null) {
      await file.writeAsBytes(bytes);
    }
    return file.path;
  }

  Future<String> exportPelanggan(List<Pelanggan> data) async {
    final excel = Excel.createExcel();
    final Sheet sheet = excel[excel.getDefaultSheet()!];

    sheet.appendRow([
      TextCellValue("ID Pelanggan"),
      TextCellValue("Nama Pelanggan"),
      TextCellValue("Alamat"),
      TextCellValue("No HP"),
    ]);

    for (var item in data) {
      sheet.appendRow([
        TextCellValue(item.id),
        TextCellValue(item.nama),
        TextCellValue(item.alamat ?? ''),
        TextCellValue(item.noHp),
      ]);
    }

    final bytes = excel.save();
    final dir = await getApplicationDocumentsDirectory();
    final file = File("${dir.path}/Laporan_Pelanggan_${DateTime.now().millisecondsSinceEpoch}.xlsx");
    if (bytes != null) {
      await file.writeAsBytes(bytes);
    }
    return file.path;
  }

  Future<String> exportServisExcel({
    required List<LaporanServis> data,
    required DateTime dari,
    required DateTime sampai,
  }) async {
    final excel = Excel.createExcel();
    excel.rename(excel.getDefaultSheet()!, 'Laporan Servis');
    final servisSheet = excel['Laporan Servis'];

    final dateFmt = DateFormat('dd MMM yyyy');
    final totalBiaya = data.fold<double>(0.0, (sum, item) => sum + item.biayaServis);
    final proses = data.where((s) => s.statusServis.toLowerCase() == 'proses').length;
    final selesai = data.where((s) => s.statusServis.toLowerCase() == 'selesai').length;

    servisSheet.appendRow([TextCellValue("Laporan Servis Rental Mobil")]);
    servisSheet.appendRow([TextCellValue("Tanggal Cetak:"), TextCellValue(dateFmt.format(DateTime.now()))]);
    servisSheet.appendRow([TextCellValue("Periode:"), TextCellValue("${dari.toIso8601String().split('T')[0]} s/d ${sampai.toIso8601String().split('T')[0]}")]);
    servisSheet.appendRow([TextCellValue("Jumlah Servis:"), IntCellValue(data.length)]);
    servisSheet.appendRow([TextCellValue("Servis Proses:"), IntCellValue(proses)]);
    servisSheet.appendRow([TextCellValue("Servis Selesai:"), IntCellValue(selesai)]);
    servisSheet.appendRow([TextCellValue("Total Biaya Servis:"), DoubleCellValue(totalBiaya)]);
    servisSheet.appendRow([]);

    servisSheet.appendRow([
      TextCellValue("Nama Mobil"),
      TextCellValue("Plat Nomor"),
      TextCellValue("Tanggal Servis"),
      TextCellValue("Jenis Servis"),
      TextCellValue("Biaya Servis"),
      TextCellValue("Status"),
      TextCellValue("Keterangan"),
    ]);

    for (var item in data) {
      servisSheet.appendRow([
        TextCellValue(item.namaMobil),
        TextCellValue(item.platNomor),
        TextCellValue(dateFmt.format(item.tanggalServis)),
        TextCellValue(item.jenisServis),
        DoubleCellValue(item.biayaServis),
        TextCellValue(item.statusServis),
        TextCellValue(item.keterangan ?? ''),
      ]);
    }

    final bytes = excel.save();
    final dir = await getApplicationDocumentsDirectory();
    final file = File("${dir.path}/laporan_servis_${DateFormat('yyyyMMdd').format(DateTime.now())}.xlsx");
    if (bytes != null) {
      await file.writeAsBytes(bytes);
    }
    return file.path;
  }

  Future<String> exportPengembalianExcel({
    required List<Pengembalian> data,
    required DateTime dari,
    required DateTime sampai,
  }) async {
    final excel = Excel.createExcel();
    excel.rename(excel.getDefaultSheet()!, 'Laporan Pengembalian');
    final returnSheet = excel['Laporan Pengembalian'];

    final dateFmt = DateFormat('dd MMM yyyy');
    final totalDendaValue = data.fold<double>(0.0, (sum, item) => sum + item.denda);
    final totalPembayaran = data.fold<double>(0.0, (sum, item) => sum + (item.totalBayar ?? 0.0));

    returnSheet.appendRow([TextCellValue("Laporan Pengembalian Rental Mobil")]);
    returnSheet.appendRow([TextCellValue("Tanggal Cetak:"), TextCellValue(dateFmt.format(DateTime.now()))]);
    returnSheet.appendRow([TextCellValue("Periode:"), TextCellValue("${dari.toIso8601String().split('T')[0]} s/d ${sampai.toIso8601String().split('T')[0]}")]);
    returnSheet.appendRow([TextCellValue("Jumlah Pengembalian:"), IntCellValue(data.length)]);
    returnSheet.appendRow([TextCellValue("Total Denda:"), DoubleCellValue(totalDendaValue)]);
    returnSheet.appendRow([TextCellValue("Total Pembayaran:"), DoubleCellValue(totalPembayaran)]);
    returnSheet.appendRow([]);

    returnSheet.appendRow([
      TextCellValue("Nama Pelanggan"),
      TextCellValue("Nama Mobil"),
      TextCellValue("Plat Nomor"),
      TextCellValue("Tanggal Sewa"),
      TextCellValue("Tanggal Estimasi"),
      TextCellValue("Tanggal Pengembalian"),
      TextCellValue("Biaya Rental"),
      TextCellValue("Denda"),
      TextCellValue("Total Bayar"),
      TextCellValue("Kondisi Mobil"),
      TextCellValue("Status Rental"),
    ]);

    for (var item in data) {
      returnSheet.appendRow([
        TextCellValue(item.namaPelanggan ?? ''),
        TextCellValue(item.namaMobil ?? ''),
        TextCellValue(item.platNomor ?? ''),
        TextCellValue(item.tanggalSewa != null ? dateFmt.format(item.tanggalSewa!) : ''),
        TextCellValue(item.tanggalEstimasi != null ? dateFmt.format(item.tanggalEstimasi!) : ''),
        TextCellValue(item.tanggalPengembalian != null ? dateFmt.format(item.tanggalPengembalian!) : ''),
        DoubleCellValue(item.totalBiaya ?? 0.0),
        DoubleCellValue(item.denda),
        DoubleCellValue(item.totalBayar ?? 0.0),
        TextCellValue(item.kondisiMobil),
        TextCellValue(item.statusRental ?? ''),
      ]);
    }

    final bytes = excel.save();
    final dir = await getApplicationDocumentsDirectory();
    final file = File("${dir.path}/laporan_pengembalian_${DateFormat('yyyyMMdd').format(DateTime.now())}.xlsx");
    if (bytes != null) {
      await file.writeAsBytes(bytes);
    }
    return file.path;
  }
}
