import 'package:flutter/material.dart';
import 'package:rental_mobil/core/utils/formatters.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  DateTime _startDate = DateTime(2026, 6, 1);
  DateTime _endDate = DateTime(2026, 6, 30);

  static const _reportTypes = [
    _ReportType(
      id: 'revenue',
      title: 'Laporan Pendapatan',
      description: 'Pendapatan dan target per periode yang dipilih',
      icon: Icons.attach_money_rounded,
      iconColorValue: 0xFF2563EB,
    ),
    _ReportType(
      id: 'rental',
      title: 'Laporan Rental',
      description: 'Riwayat seluruh transaksi rental kendaraan',
      icon: Icons.receipt_long_rounded,
      iconColorValue: 0xFF16A34A,
    ),
    _ReportType(
      id: 'cars',
      title: 'Laporan Armada',
      description: 'Status, kondisi, dan utilisasi setiap kendaraan',
      icon: Icons.directions_car_rounded,
      iconColorValue: 0xFFD97706,
    ),
    _ReportType(
      id: 'customers',
      title: 'Laporan Pelanggan',
      description: 'Data lengkap & aktivitas seluruh pelanggan',
      icon: Icons.people_rounded,
      iconColorValue: 0xFF7C3AED,
    ),
  ];

  Future<void> _pickDate(bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isStart ? _startDate : _endDate,
      firstDate: DateTime(2024),
      lastDate: DateTime(2027),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  void _downloadReport(String title, String format) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.download_rounded, color: Colors.white, size: 18),
            const SizedBox(width: 10),
            Text('$title ($format) sedang diunduh...'),
          ],
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text('Laporan', style: textTheme.headlineMedium),
          const SizedBox(height: 4),
          Text(
            'Unduh berbagai laporan operasional MULTI RENTCAR',
            style: textTheme.bodyMedium
                ?.copyWith(color: colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 24),

          // Date Range Selector
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.date_range_rounded,
                          size: 18, color: colorScheme.primary),
                      const SizedBox(width: 8),
                      Text('Rentang Periode Laporan',
                          style: textTheme.titleMedium),
                    ],
                  ),
                  const SizedBox(height: 16),
                  LayoutBuilder(builder: (context, constraints) {
                    final isWide = constraints.maxWidth > 500;
                    final children = [
                      Expanded(
                        child: _DateField(
                          label: 'Dari Tanggal',
                          date: _startDate,
                          onTap: () => _pickDate(true),
                        ),
                      ),
                      isWide
                          ? const SizedBox(width: 16)
                          : const SizedBox(height: 12),
                      Expanded(
                        child: _DateField(
                          label: 'Sampai Tanggal',
                          date: _endDate,
                          onTap: () => _pickDate(false),
                        ),
                      ),
                    ];
                    return isWide
                        ? Row(children: children)
                        : Column(children: children);
                  }),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: colorScheme.primary.withOpacity(0.2)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline_rounded,
                            size: 16, color: colorScheme.primary),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Menampilkan data dari ${Formatters.date(_startDate)} hingga ${Formatters.date(_endDate)}',
                            style: textTheme.bodySmall
                                ?.copyWith(color: colorScheme.primary),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Report Type Cards
          Text('Pilih Jenis Laporan', style: textTheme.titleLarge),
          const SizedBox(height: 12),
          LayoutBuilder(builder: (context, constraints) {
            final isWide = constraints.maxWidth > 600;
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isWide ? 2 : 1,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: isWide ? 2.4 : 2.8,
              ),
              itemCount: _reportTypes.length,
              itemBuilder: (context, i) => _ReportCard(
                reportType: _reportTypes[i],
                onDownload: (format) =>
                    _downloadReport(_reportTypes[i].title, format),
              ),
            );
          }),
          const SizedBox(height: 24),

          // Summary Stats
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.summarize_rounded,
                          size: 18, color: colorScheme.primary),
                      const SizedBox(width: 8),
                      Text('Ringkasan Periode', style: textTheme.titleMedium),
                    ],
                  ),
                  const SizedBox(height: 16),
                  LayoutBuilder(builder: (context, constraints) {
                    final isWide = constraints.maxWidth > 500;
                    return Flex(
                      direction: isWide ? Axis.horizontal : Axis.vertical,
                      children: [
                        _SummaryStat(
                          label: 'Total Pendapatan',
                          value: 'Rp 24,8 Juta',
                          icon: Icons.attach_money_rounded,
                        ),
                        SizedBox(
                            width: isWide ? 0 : 12,
                            height: isWide ? 12 : 0),
                        _SummaryStat(
                          label: 'Total Transaksi',
                          value: '68 Transaksi',
                          icon: Icons.receipt_long_rounded,
                        ),
                        SizedBox(
                            width: isWide ? 0 : 12,
                            height: isWide ? 12 : 0),
                        _SummaryStat(
                          label: 'Tingkat Utilisasi',
                          value: '70.8%',
                          icon: Icons.speed_rounded,
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  final String label;
  final DateTime date;
  final VoidCallback onTap;

  const _DateField({
    required this.label,
    required this.date,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: textTheme.bodySmall
                ?.copyWith(color: colorScheme.onSurfaceVariant)),
        const SizedBox(height: 6),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: colorScheme.outline),
              borderRadius: BorderRadius.circular(8),
              color: colorScheme.surfaceContainerHighest,
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today_rounded,
                    size: 16, color: colorScheme.onSurfaceVariant),
                const SizedBox(width: 8),
                Text(Formatters.date(date), style: textTheme.bodyMedium),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ReportCard extends StatelessWidget {
  final _ReportType reportType;
  final void Function(String format) onDownload;

  const _ReportCard({
    required this.reportType,
    required this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final iconColor = Color(reportType.iconColorValue);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(reportType.icon, size: 24, color: iconColor),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    reportType.title,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    reportType.description,
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton.icon(
                  onPressed: () => onDownload('PDF'),
                  icon: const Icon(Icons.picture_as_pdf_rounded, size: 14),
                  label: const Text('PDF'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 8),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    textStyle: const TextStyle(fontSize: 12),
                  ),
                ),
                const SizedBox(height: 6),
                OutlinedButton.icon(
                  onPressed: () => onDownload('Excel'),
                  icon: const Icon(Icons.table_chart_rounded, size: 14),
                  label: const Text('Excel'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 8),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    textStyle: const TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ReportType {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final int iconColorValue;

  const _ReportType({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.iconColorValue,
  });
}

class _SummaryStat extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _SummaryStat({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: colorScheme.primary),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(value,
                      style: textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  Text(label,
                      style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
