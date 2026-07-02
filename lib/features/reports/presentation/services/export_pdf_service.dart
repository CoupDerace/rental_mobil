import 'dart:io';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import '../../../cars/domain/entities/car.dart';
import '../../../pelanggan/domain/entities/pelanggan.dart';
import '../../../pengembalian/domain/entities/pengembalian.dart';
import '../../domain/entities/report.dart';

class ExportPdfService {
  Future<String> exportPendapatan({
    required List<LaporanPendapatan> data,
    required DateTime dari,
    required DateTime sampai,
  }) async {
    final pdf = pw.Document();
    
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

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          pw.Header(level: 0, text: "Laporan Pendapatan Rental Mobil"),
          pw.Paragraph(
              text: "Periode: ${dari.toIso8601String().split('T')[0]} s/d ${sampai.toIso8601String().split('T')[0]}"),
          pw.SizedBox(height: 10),
          pw.TableHelper.fromTextArray(
            headers: ["Tanggal", "ID", "Mobil", "Pelanggan", "Metode", "Jumlah"],
            data: filtered.map((item) => [
              item.tanggalBayar,
              item.idPembayaran,
              item.namaMobil,
              item.namaPelanggan,
              item.metodePembayaran,
              NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(item.jumlahBayar),
            ]).toList(),
          ),
        ],
      ),
    );

    final dir = await getApplicationDocumentsDirectory();
    final file = File("${dir.path}/Laporan_Pendapatan_${DateTime.now().millisecondsSinceEpoch}.pdf");
    await file.writeAsBytes(await pdf.save());
    return file.path;
  }

  Future<String> exportRental({
    required List<LaporanTransaksiRental> data,
    required DateTime dari,
    required DateTime sampai,
  }) async {
    final pdf = pw.Document();

    final filtered = data.where((item) {
      return item.tanggalSewa.isAfter(dari.subtract(const Duration(days: 1))) &&
          item.tanggalSewa.isBefore(sampai.add(const Duration(days: 1)));
    }).toList();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          pw.Header(level: 0, text: "Laporan Transaksi Rental Mobil"),
          pw.Paragraph(
              text: "Periode: ${dari.toIso8601String().split('T')[0]} s/d ${sampai.toIso8601String().split('T')[0]}"),
          pw.SizedBox(height: 10),
          pw.TableHelper.fromTextArray(
            headers: ["Pelanggan", "Mobil", "Plat", "Sewa", "Kembali", "Status", "Biaya"],
            data: filtered.map((item) => [
              item.namaPelanggan,
              item.namaMobil,
              item.platNomor,
              item.tanggalSewa.toIso8601String().split('T')[0],
              item.tanggalKembali.toIso8601String().split('T')[0],
              item.statusRental,
              NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(item.totalBiaya),
            ]).toList(),
          ),
        ],
      ),
    );

    final dir = await getApplicationDocumentsDirectory();
    final file = File("${dir.path}/Laporan_Rental_${DateTime.now().millisecondsSinceEpoch}.pdf");
    await file.writeAsBytes(await pdf.save());
    return file.path;
  }

  Future<String> exportArmada(List<Car> data) async {
    final pdf = pw.Document();
    
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          pw.Header(level: 0, text: "Laporan Daftar Armada Mobil"),
          pw.SizedBox(height: 10),
          pw.TableHelper.fromTextArray(
            headers: ["Nama Mobil", "Plat Nomor", "Harga Sewa / Hari", "Status"],
            data: data.map((item) => [
              item.namaMobil,
              item.platNomor,
              NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(item.hargaSewaPerhari),
              item.statusMobil,
            ]).toList(),
          ),
        ],
      ),
    );

    final dir = await getApplicationDocumentsDirectory();
    final file = File("${dir.path}/Laporan_Armada_${DateTime.now().millisecondsSinceEpoch}.pdf");
    await file.writeAsBytes(await pdf.save());
    return file.path;
  }

  Future<String> exportPelanggan(List<Pelanggan> data) async {
    final pdf = pw.Document();
    
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          pw.Header(level: 0, text: "Laporan Daftar Pelanggan"),
          pw.SizedBox(height: 10),
          pw.TableHelper.fromTextArray(
            headers: ["ID", "Nama Pelanggan", "Alamat", "No HP"],
            data: data.map((item) => [
              item.id,
              item.nama,
              item.alamat,
              item.noHp,
            ]).toList(),
          ),
        ],
      ),
    );

    final dir = await getApplicationDocumentsDirectory();
    final file = File("${dir.path}/Laporan_Pelanggan_${DateTime.now().millisecondsSinceEpoch}.pdf");
    await file.writeAsBytes(await pdf.save());
    return file.path;
  }

  Future<String> exportServis({
    required List<LaporanServis> data,
    required DateTime dari,
    required DateTime sampai,
  }) async {
    final pdf = pw.Document();
    final dateFmt = DateFormat('dd MMM yyyy');
    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    final totalBiaya = data.fold<double>(0.0, (sum, item) => sum + item.biayaServis);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          pw.Header(level: 0, text: "LAPORAN SERVIS RENTAL MOBIL"),
          pw.Paragraph(text: "Tanggal Cetak: ${dateFmt.format(DateTime.now())}"),
          pw.Paragraph(
              text: "Periode: ${dari.toIso8601String().split('T')[0]} s/d ${sampai.toIso8601String().split('T')[0]}"),
          pw.Paragraph(text: "Jumlah Servis: ${data.length}"),
          pw.Paragraph(text: "Total Biaya Servis: ${currencyFormat.format(totalBiaya)}"),
          pw.SizedBox(height: 10),
          pw.TableHelper.fromTextArray(
            headers: ["Nama Mobil", "Plat Nomor", "Tanggal", "Jenis Servis", "Biaya", "Status", "Keterangan"],
            data: data.map((item) {
              return [
                item.namaMobil,
                item.platNomor,
                dateFmt.format(item.tanggalServis),
                item.jenisServis,
                currencyFormat.format(item.biayaServis),
                item.statusServis,
                item.keterangan ?? '',
              ];
            }).toList(),
          ),
          pw.SizedBox(height: 20),
          pw.Align(
            alignment: pw.Alignment.centerRight,
            child: pw.Text(
              "TOTAL BIAYA SERVIS: ${currencyFormat.format(totalBiaya)}",
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14),
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Align(
            alignment: pw.Alignment.center,
            child: pw.Text(
              "Dicetak otomatis oleh Sistem Rental Mobil",
              style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey),
            ),
          ),
        ],
      ),
    );

    final dir = await getApplicationDocumentsDirectory();
    final file = File("${dir.path}/laporan_servis_${DateFormat('yyyyMMdd').format(DateTime.now())}.pdf");
    await file.writeAsBytes(await pdf.save());
    return file.path;
  }

  Future<String> exportPengembalian({
    required List<Pengembalian> data,
    required DateTime dari,
    required DateTime sampai,
  }) async {
    final pdf = pw.Document();
    final dateFmt = DateFormat('dd MMM yyyy');
    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    final totalDendaValue = data.fold<double>(0.0, (sum, item) => sum + item.denda);
    final totalPembayaran = data.fold<double>(0.0, (sum, item) => sum + (item.totalBayar ?? 0.0));

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.landscape,
        build: (context) => [
          pw.Header(level: 0, text: "LAPORAN PENGEMBALIAN RENTAL MOBIL"),
          pw.Paragraph(text: "Tanggal Cetak: ${dateFmt.format(DateTime.now())}"),
          pw.Paragraph(
              text: "Periode: ${dari.toIso8601String().split('T')[0]} s/d ${sampai.toIso8601String().split('T')[0]}"),
          pw.SizedBox(height: 10),
          pw.TableHelper.fromTextArray(
            headers: [
              "Nama Pelanggan",
              "Nama Mobil",
              "Plat Nomor",
              "Tanggal Sewa",
              "Tanggal Estimasi",
              "Tanggal Pengembalian",
              "Biaya Rental",
              "Denda",
              "Total Bayar",
              "Kondisi Mobil",
              "Status Rental"
            ],
            data: data.map((item) {
              return [
                item.namaPelanggan ?? '',
                item.namaMobil ?? '',
                item.platNomor ?? '',
                item.tanggalSewa != null ? dateFmt.format(item.tanggalSewa!) : '',
                item.tanggalEstimasi != null ? dateFmt.format(item.tanggalEstimasi!) : '',
                item.tanggalPengembalian != null ? dateFmt.format(item.tanggalPengembalian!) : '',
                currencyFormat.format(item.totalBiaya ?? 0.0),
                currencyFormat.format(item.denda),
                currencyFormat.format(item.totalBayar ?? 0.0),
                item.kondisiMobil,
                item.statusRental ?? '',
              ];
            }).toList(),
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8),
            cellStyle: const pw.TextStyle(fontSize: 8),
          ),
          pw.SizedBox(height: 20),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text("Jumlah Pengembalian: ${data.length}", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
                  pw.Text("Total Denda: ${currencyFormat.format(totalDendaValue)}", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
                  pw.Text("Total Pembayaran: ${currencyFormat.format(totalPembayaran)}", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
                ],
              ),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Text("Tanggal Cetak: ${dateFmt.format(DateTime.now())}", style: const pw.TextStyle(fontSize: 10)),
                ],
              ),
            ],
          ),
          pw.SizedBox(height: 20),
          pw.Align(
            alignment: pw.Alignment.center,
            child: pw.Text(
              "Dicetak otomatis oleh Sistem Rental Mobil",
              style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey),
            ),
          ),
        ],
      ),
    );

    final dir = await getApplicationDocumentsDirectory();
    final file = File("${dir.path}/laporan_pengembalian_${DateFormat('yyyyMMdd').format(DateTime.now())}.pdf");
    await file.writeAsBytes(await pdf.save());
    return file.path;
  }
}
