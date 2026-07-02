import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:open_filex/open_filex.dart';
import '../../../../app/routes/injector.dart';
import '../../../../app/routes/routes.dart';
import '../../../../shared/providers/auth_provider.dart';
import '../../../../core/components/organism/app_scaffold.dart';
import '../providers/reports_provider.dart';
import '../services/export_pdf_service.dart';
import '../services/export_excel_service.dart';
import '../widgets/laporan_summary_card.dart';
import '../widgets/laporan_pendapatan_table.dart';
import '../widgets/laporan_rental_table.dart';
import '../widgets/laporan_mobil_table.dart';
import '../widgets/laporan_servis_table.dart';
import '../widgets/laporan_pengembalian_table.dart';
import 'pdf_preview_page.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _dateFormat = DateFormat('yyyy-MM-dd');

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _selectDariTanggal(BuildContext context, ReportsProvider provider) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: provider.dariTanggal,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      provider.setDariTanggal(picked);
    }
  }

  Future<void> _selectSampaiTanggal(BuildContext context, ReportsProvider provider) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: provider.sampaiTanggal,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      provider.setSampaiTanggal(picked);
    }
  }

  Future<void> _handleExcelExport(BuildContext context, String savedPath, String defaultFileName) async {
    try {
      await OpenFilex.open(savedPath);

      if (context.mounted) {
        _showExcelActionDialog(context, savedPath);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Gagal menyimpan file Excel: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showExcelActionDialog(BuildContext context, String savedPath) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(
          "Laporan Excel Berhasil Disimpan",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF1E2A44),
        content: Text(
          "Laporan disimpan ke:\n$savedPath\n\nApakah Anda ingin membuka atau membagikan file ini?",
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Tutup", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await OpenFilex.open(savedPath);
            },
            child: const Text("Buka File", style: TextStyle(color: Color(0xFFFF7A1A))),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await SharePlus.instance.share(
                ShareParams(
                  files: [XFile(savedPath)],
                  text: 'Laporan Excel',
                ),
              );
            },
            child: const Text("Share / WhatsApp", style: TextStyle(color: Color(0xFF22C55E))),
          ),
        ],
      ),
    );
  }

  void _previewPdf(BuildContext context, String path, String defaultFileName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PdfPreviewPage(
          pdfPath: path,
          fileName: defaultFileName,
        ),
      ),
    );
  }

  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final auth = context.watch<AuthProvider>();
    final role = auth.role.toLowerCase();

    // Redirect Operator
    if (role == 'operator') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, AppRoutes.operatorDashboard);
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return ChangeNotifierProvider(
      create: (_) => sl<ReportsProvider>()..fetchReportData(),
      child: Consumer<ReportsProvider>(
        builder: (context, provider, child) {
          if (provider.loading) {
            return const AppScaffold(
              title: "Laporan & Statistik",
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (provider.error != null) {
            return AppScaffold(
              title: "Laporan & Statistik",
              body: Center(
                child: Text(
                  "Error: ${provider.error}",
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            );
          }

          final summary = provider.reportData?.summary;

          return AppScaffold(
            title: "Laporan & Statistik",
            body: RefreshIndicator(
              onRefresh: () => provider.fetchReportData(),
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  // Page Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Laporan Operasional & Pendapatan",
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Inter',
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Ringkasan performa bisnis, pendapatan harian, popularitas armada, dan export berkas",
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                                fontFamily: 'Inter',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Section 1: Summary Cards
                  if (summary != null) ...[
                    LaporanSummaryCard(summary: summary),
                    const SizedBox(height: 24),
                  ],

                  // TOTAL BIAYA SERVIS & TOTAL PENGEMBALIAN summary cards
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final isWide = constraints.maxWidth > 600;
                      final cardServis = Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFF7A1A).withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.build_circle_outlined,
                                  color: Color(0xFFFF7A1A),
                                  size: 28,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "TOTAL BIAYA SERVIS",
                                      overflow: TextOverflow.ellipsis,
                                      style: theme.textTheme.bodyMedium?.copyWith(
                                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        NumberFormat.currency(
                                          locale: 'id_ID',
                                          symbol: 'Rp ',
                                          decimalDigits: 0,
                                        ).format(provider.totalBiayaServis),
                                        style: theme.textTheme.headlineSmall?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Inter',
                                          color: theme.colorScheme.onSurface,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );

                      final cardPengembalian = Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.green.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.assignment_return_outlined,
                                  color: Colors.green,
                                  size: 28,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "TOTAL PENGEMBALIAN",
                                      overflow: TextOverflow.ellipsis,
                                      style: theme.textTheme.bodyMedium?.copyWith(
                                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        NumberFormat.currency(
                                          locale: 'id_ID',
                                          symbol: 'Rp ',
                                          decimalDigits: 0,
                                        ).format(provider.totalBayarPengembalian),
                                        style: theme.textTheme.headlineSmall?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Inter',
                                          color: theme.colorScheme.onSurface,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );

                      if (isWide) {
                        return Row(
                          children: [
                            Expanded(child: cardServis),
                            const SizedBox(width: 16),
                            Expanded(child: cardPengembalian),
                          ],
                        );
                      } else {
                        return Column(
                          children: [
                            cardServis,
                            const SizedBox(height: 16),
                            cardPengembalian,
                          ],
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 24),

                  // Main Content Grid (Unduh Card and Tables Tabbed Card)
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final isWide = constraints.maxWidth > 900;
                      final unduhCard = _buildUnduhCard(context, provider);
                      final tablesCard = _buildTablesCard(context, provider);

                      if (isWide) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(width: 320, child: unduhCard),
                            const SizedBox(width: 24),
                            Expanded(child: tablesCard),
                          ],
                        );
                      } else {
                        return Column(
                          children: [
                            unduhCard,
                            const SizedBox(height: 24),
                            tablesCard,
                          ],
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildUnduhCard(BuildContext context, ReportsProvider provider) {
    final theme = Theme.of(context);
    final pdfService = ExportPdfService();
    final excelService = ExportExcelService();

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.dividerColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Unduh Laporan",
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 16),

            // Dari Tanggal
            GestureDetector(
              onTap: () => _selectDariTanggal(context, provider),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: theme.dividerColor),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Dari: ${_dateFormat.format(provider.dariTanggal)}",
                      style: theme.textTheme.bodyMedium?.copyWith(fontFamily: 'Inter'),
                    ),
                    const Icon(Icons.calendar_today, size: 16),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Sampai Tanggal
            GestureDetector(
              onTap: () => _selectSampaiTanggal(context, provider),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: theme.dividerColor),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Sampai: ${_dateFormat.format(provider.sampaiTanggal)}",
                      style: theme.textTheme.bodyMedium?.copyWith(fontFamily: 'Inter'),
                    ),
                    const Icon(Icons.calendar_today, size: 16),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            const Divider(),
            const SizedBox(height: 12),

            // Items
            _buildExportRow(
              context,
              title: "Laporan Pendapatan",
              onPdf: () async {
                final path = await pdfService.exportPendapatan(
                  data: provider.reportData?.pendapatan ?? [],
                  dari: provider.dariTanggal,
                  sampai: provider.sampaiTanggal,
                );
                if (context.mounted) _previewPdf(context, path, "Laporan_Pendapatan.pdf");
              },
              onExcel: () async {
                final path = await excelService.exportPendapatan(
                  data: provider.reportData?.pendapatan ?? [],
                  dari: provider.dariTanggal,
                  sampai: provider.sampaiTanggal,
                );
                if (context.mounted) await _handleExcelExport(context, path, "Laporan_Pendapatan.xlsx");
              },
            ),
            const SizedBox(height: 16),

            _buildExportRow(
              context,
              title: "Laporan Rental",
              onPdf: () async {
                final path = await pdfService.exportRental(
                  data: provider.reportData?.rental ?? [],
                  dari: provider.dariTanggal,
                  sampai: provider.sampaiTanggal,
                );
                if (context.mounted) _previewPdf(context, path, "Laporan_Rental.pdf");
              },
              onExcel: () async {
                final path = await excelService.exportRental(
                  data: provider.reportData?.rental ?? [],
                  dari: provider.dariTanggal,
                  sampai: provider.sampaiTanggal,
                );
                if (context.mounted) await _handleExcelExport(context, path, "Laporan_Rental.xlsx");
              },
            ),
            const SizedBox(height: 16),

            _buildExportRow(
              context,
              title: "Laporan Armada",
              onPdf: () async {
                final path = await pdfService.exportArmada(provider.cars);
                if (context.mounted) _previewPdf(context, path, "Laporan_Armada.pdf");
              },
              onExcel: () async {
                final path = await excelService.exportArmada(provider.cars);
                if (context.mounted) await _handleExcelExport(context, path, "Laporan_Armada.xlsx");
              },
            ),
            const SizedBox(height: 16),

            _buildExportRow(
              context,
              title: "Laporan Pelanggan",
              onPdf: () async {
                final path = await pdfService.exportPelanggan(provider.pelanggan);
                if (context.mounted) _previewPdf(context, path, "Laporan_Pelanggan.pdf");
              },
              onExcel: () async {
                final path = await excelService.exportPelanggan(provider.pelanggan);
                if (context.mounted) await _handleExcelExport(context, path, "Laporan_Pelanggan.xlsx");
              },
            ),
            const SizedBox(height: 16),
            _buildExportRow(
              context,
              title: "Laporan Servis",
              onPdf: () async {
                _showLoadingDialog(context);
                try {
                  final path = await pdfService.exportServis(
                    data: provider.filteredServis,
                    dari: provider.dariTanggal,
                    sampai: provider.sampaiTanggal,
                  );
                  if (context.mounted) {
                    Navigator.pop(context);
                    _previewPdf(context, path, "laporan_servis_${DateFormat('yyyyMMdd').format(DateTime.now())}.pdf");
                    await OpenFilex.open(path);
                  }
                } catch (e) {
                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Gagal export PDF: $e"), backgroundColor: Colors.red),
                    );
                  }
                }
              },
              onExcel: () async {
                _showLoadingDialog(context);
                try {
                  final path = await excelService.exportServisExcel(
                    data: provider.filteredServis,
                    dari: provider.dariTanggal,
                    sampai: provider.sampaiTanggal,
                  );
                  if (context.mounted) {
                    Navigator.pop(context);
                    await _handleExcelExport(context, path, "laporan_servis_${DateFormat('yyyyMMdd').format(DateTime.now())}.xlsx");
                  }
                } catch (e) {
                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Gagal export Excel: $e"), backgroundColor: Colors.red),
                    );
                  }
                }
              },
            ),
            const SizedBox(height: 16),
            _buildExportRow(
              context,
              title: "Laporan Pengembalian",
              onPdf: () async {
                _showLoadingDialog(context);
                try {
                  final path = await pdfService.exportPengembalian(
                    data: provider.filteredPengembalian,
                    dari: provider.dariTanggal,
                    sampai: provider.sampaiTanggal,
                  );
                  if (context.mounted) {
                    Navigator.pop(context);
                    _previewPdf(context, path, "laporan_pengembalian_${DateFormat('yyyyMMdd').format(DateTime.now())}.pdf");
                    await OpenFilex.open(path);
                  }
                } catch (e) {
                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Gagal export PDF: $e"), backgroundColor: Colors.red),
                    );
                  }
                }
              },
              onExcel: () async {
                _showLoadingDialog(context);
                try {
                  final path = await excelService.exportPengembalianExcel(
                    data: provider.filteredPengembalian,
                    dari: provider.dariTanggal,
                    sampai: provider.sampaiTanggal,
                  );
                  if (context.mounted) {
                    Navigator.pop(context);
                    await _handleExcelExport(context, path, "laporan_pengembalian_${DateFormat('yyyyMMdd').format(DateTime.now())}.xlsx");
                  }
                } catch (e) {
                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Gagal export Excel: $e"), backgroundColor: Colors.red),
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExportRow(
    BuildContext context, {
    required String title,
    required VoidCallback onPdf,
    required VoidCallback onExcel,
  }) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            fontFamily: 'Inter',
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.picture_as_pdf, size: 14),
                label: const Text("PDF", style: TextStyle(fontSize: 12)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF7A1A).withValues(alpha: 0.15),
                  foregroundColor: const Color(0xFFFF7A1A),
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                ),
                onPressed: onPdf,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.table_view, size: 14),
                label: const Text("EXCEL", style: TextStyle(fontSize: 12)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal.withValues(alpha: 0.15),
                  foregroundColor: Colors.teal,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                ),
                onPressed: onExcel,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTablesCard(BuildContext context, ReportsProvider provider) {
    final theme = Theme.of(context);
    final phList = provider.reportData?.pendapatanHarian ?? [];
    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TabBar(
            isScrollable: true,
            controller: _tabController,
            labelColor: const Color(0xFFFF7A1A),
            unselectedLabelColor: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            indicatorColor: const Color(0xFFFF7A1A),
            tabs: const [
              Tab(text: "Pendapatan"),
              Tab(text: "Rental"),
              Tab(text: "Armada Populer"),
              Tab(text: "Harian"),
              Tab(text: "Servis"),
              Tab(text: "Pengembalian"),
            ],
          ),
          SizedBox(
            height: 480,
            child: TabBarView(
              controller: _tabController,
              children: [
                // Tab 1: Pendapatan
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      TextField(
                        controller: provider.pendapatanSearchController,
                        decoration: InputDecoration(
                          hintText: "Cari Pendapatan (Pelanggan, Mobil, Metode)...",
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          contentPadding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                        onChanged: provider.onSearchChanged,
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: LaporanPendapatanTable(list: provider.filteredPendapatan),
                      ),
                    ],
                  ),
                ),

                // Tab 2: Rental
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      TextField(
                        controller: provider.rentalSearchController,
                        decoration: InputDecoration(
                          hintText: "Cari Transaksi Rental (Pelanggan, Mobil, Plat, Status)...",
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          contentPadding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                        onChanged: provider.onSearchChanged,
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: LaporanRentalTable(list: provider.filteredRental),
                      ),
                    ],
                  ),
                ),

                // Tab 3: Armada Populer
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: LaporanMobilTable(list: provider.reportData?.mobilPopuler ?? []),
                ),

                // Tab 4: Pendapatan Harian
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: phList.isEmpty
                      ? const Center(child: Text("Tidak ada data harian"))
                      : SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columns: const [
                              DataColumn(label: Text("Tanggal")),
                              DataColumn(label: Text("Total Pendapatan")),
                            ],
                            rows: phList.map((item) {
                              return DataRow(
                                cells: [
                                  DataCell(Text(item.tanggal)),
                                  DataCell(Text(currencyFormat.format(item.total))),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                ),

                // Tab 5: Servis
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      TextField(
                        controller: provider.servisSearchController,
                        decoration: InputDecoration(
                          hintText: "Cari Servis (Mobil, Plat, Jenis)...",
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          contentPadding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                        onChanged: provider.onSearchChanged,
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: LaporanServisTable(list: provider.filteredServis),
                      ),
                    ],
                  ),
                ),

                // Tab 6: Pengembalian
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      TextField(
                        controller: provider.pengembalianSearchController,
                        decoration: InputDecoration(
                          hintText: "Cari Pengembalian (Pelanggan, Mobil, Plat, Status, Kondisi)...",
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          contentPadding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                        onChanged: provider.onSearchChanged,
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: LaporanPengembalianTable(list: provider.filteredPengembalian),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
