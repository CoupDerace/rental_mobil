import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:rental_mobil/core/theme/app_theme.dart';
import 'package:rental_mobil/core/utils/formatters.dart';
import 'package:rental_mobil/features/auth/data/models/car_model.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

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
          Text('Dashboard', style: textTheme.headlineMedium),
          const SizedBox(height: 4),
          Text(
            'Selamat datang di Multi RentCar Management System',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),

          // KPI Cards
          _KpiGrid(),
          const SizedBox(height: 24),

          // Charts row
          LayoutBuilder(builder: (context, constraints) {
            final isWide = constraints.maxWidth > 700;
            if (isWide) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _RevenueLineChart()),
                  const SizedBox(width: 16),
                  Expanded(child: _TopCarsBarChart()),
                ],
              );
            }
            return Column(
              children: [
                _RevenueLineChart(),
                const SizedBox(height: 16),
                _TopCarsBarChart(),
              ],
            );
          }),
          const SizedBox(height: 24),

          // Recent Activity Table
          _RecentActivityCard(),
        ],
      ),
    );
  }
}

// ─── KPI Grid ──────────────────────────────────────────────────────────────

class _KpiGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final successColor = AppTheme.successColor(context);
    final warningColor = AppTheme.warningColor(context);

    final items = [
      _KpiData(
        title: 'Total Mobil',
        value: '48',
        icon: Icons.directions_car_rounded,
        iconBg: colorScheme.primary.withOpacity(0.12),
        iconColor: colorScheme.primary,
      ),
      _KpiData(
        title: 'Mobil Tersedia',
        value: '32',
        icon: Icons.check_circle_outline_rounded,
        iconBg: successColor.withOpacity(0.12),
        iconColor: successColor,
      ),
      _KpiData(
        title: 'Mobil Disewa',
        value: '14',
        icon: Icons.cancel_outlined,
        iconBg: warningColor.withOpacity(0.12),
        iconColor: warningColor,
      ),
      _KpiData(
        title: 'Pendapatan Bulan Ini',
        value: Formatters.currencyShort(24800000),
        icon: Icons.attach_money_rounded,
        iconBg: colorScheme.tertiary.withOpacity(0.12),
        iconColor: colorScheme.tertiary,
      ),
    ];

    return LayoutBuilder(builder: (context, constraints) {
      final crossAxisCount = constraints.maxWidth > 700 ? 4 : 2;
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.5,
        ),
        itemCount: items.length,
        itemBuilder: (context, i) => _KpiCard(data: items[i]),
      );
    });
  }
}

class _KpiData {
  final String title;
  final String value;
  final IconData icon;
  final Color iconBg;
  final Color iconColor;

  const _KpiData({
    required this.title,
    required this.value,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
  });
}

class _KpiCard extends StatelessWidget {
  final _KpiData data;

  const _KpiCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: data.iconBg,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(data.icon, size: 20, color: data.iconColor),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title,
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  data.value,
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
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

// ─── Revenue Line Chart ────────────────────────────────────────────────────

class _RevenueLineChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final data = SampleData.revenueData;

    final spots = data.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(), e.value.revenue / 1000000);
    }).toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.trending_up_rounded,
                    size: 18, color: colorScheme.primary),
                const SizedBox(width: 8),
                Text('Pendapatan 6 Bulan Terakhir',
                    style: textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 220,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (_) => FlLine(
                      color: colorScheme.outline.withOpacity(0.5),
                      strokeWidth: 1,
                    ),
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 44,
                        getTitlesWidget: (value, meta) => Text(
                          '${value.toInt()}M',
                          style: TextStyle(
                            fontSize: 10,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final idx = value.toInt();
                          if (idx < 0 || idx >= data.length) {
                            return const SizedBox.shrink();
                          }
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              data[idx].month,
                              style: TextStyle(
                                fontSize: 11,
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      color: colorScheme.primary,
                      barWidth: 2.5,
                      dotData: FlDotData(
                        getDotPainter: (spot, percent, bar, index) =>
                            FlDotCirclePainter(
                          radius: 4,
                          color: colorScheme.primary,
                          strokeWidth: 2,
                          strokeColor: colorScheme.surface,
                        ),
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        color: colorScheme.primary.withOpacity(0.08),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Top Cars Bar Chart ────────────────────────────────────────────────────

class _TopCarsBarChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final data = SampleData.topCars;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.directions_car_rounded,
                    size: 18, color: colorScheme.primary),
                const SizedBox(width: 8),
                Text('Mobil Paling Sering Disewa',
                    style: textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 220,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 50,
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (_) => FlLine(
                      color: colorScheme.outline.withOpacity(0.5),
                      strokeWidth: 1,
                    ),
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 28,
                        getTitlesWidget: (value, meta) => Text(
                          value.toInt().toString(),
                          style: TextStyle(
                            fontSize: 10,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final idx = value.toInt();
                          if (idx < 0 || idx >= data.length) {
                            return const SizedBox.shrink();
                          }
                          // Abbreviate names
                          final parts = data[idx].name.split(' ');
                          final abbr = parts.length > 1
                              ? parts[1]
                              : parts[0];
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              abbr,
                              style: TextStyle(
                                fontSize: 10,
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: data.asMap().entries.map((e) {
                    return BarChartGroupData(
                      x: e.key,
                      barRods: [
                        BarChartRodData(
                          toY: e.value.rentals.toDouble(),
                          color: colorScheme.primary,
                          width: 28,
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(4)),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Recent Activity Table ─────────────────────────────────────────────────

class _RecentActivityCard extends StatelessWidget {
  static const _activities = [
    _ActivityRow(
        type: 'Rental',
        customer: 'Budi Santoso',
        car: 'Toyota Avanza',
        date: '2026-06-08',
        status: TransactionStatus.active),
    _ActivityRow(
        type: 'Return',
        customer: 'Ani Wijaya',
        car: 'Honda Jazz',
        date: '2026-06-08',
        status: TransactionStatus.completed),
    _ActivityRow(
        type: 'Payment',
        customer: 'Citra Dewi',
        car: 'Mitsubishi Xpander',
        date: '2026-06-07',
        status: TransactionStatus.completed),
    _ActivityRow(
        type: 'Service',
        customer: '-',
        car: 'Suzuki Ertiga',
        date: '2026-06-07',
        status: TransactionStatus.pending),
    _ActivityRow(
        type: 'Rental',
        customer: 'Dedi Kusuma',
        car: 'Daihatsu Terios',
        date: '2026-06-06',
        status: TransactionStatus.active),
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.access_time_rounded,
                    size: 18, color: colorScheme.primary),
                const SizedBox(width: 8),
                Text('Aktivitas Terbaru', style: textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowColor: WidgetStatePropertyAll(
                    colorScheme.surfaceContainerHighest),
                columnSpacing: 24,
                horizontalMargin: 16,
                columns: const [
                  DataColumn(label: Text('Tipe')),
                  DataColumn(label: Text('Customer')),
                  DataColumn(label: Text('Mobil')),
                  DataColumn(label: Text('Tanggal')),
                  DataColumn(label: Text('Status')),
                ],
                rows: _activities.map((a) {
                  return DataRow(cells: [
                    DataCell(Text(a.type)),
                    DataCell(Text(a.customer)),
                    DataCell(Text(a.car)),
                    DataCell(Text(Formatters.dateFromString(a.date))),
                    DataCell(_StatusBadge(status: a.status)),
                  ]);
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActivityRow {
  final String type;
  final String customer;
  final String car;
  final String date;
  final TransactionStatus status;

  const _ActivityRow({
    required this.type,
    required this.customer,
    required this.car,
    required this.date,
    required this.status,
  });
}

class _StatusBadge extends StatelessWidget {
  final TransactionStatus status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;

    switch (status) {
      case TransactionStatus.completed:
        bgColor = AppTheme.successColor(context).withOpacity(0.15);
        textColor = AppTheme.successColor(context);
        break;
      case TransactionStatus.active:
        bgColor = Theme.of(context).colorScheme.primary.withOpacity(0.12);
        textColor = Theme.of(context).colorScheme.primary;
        break;
      case TransactionStatus.pending:
        bgColor = AppTheme.warningColor(context).withOpacity(0.15);
        textColor = AppTheme.warningColor(context);
        break;
      case TransactionStatus.cancelled:
        bgColor = AppTheme.errorColor(context).withOpacity(0.12);
        textColor = AppTheme.errorColor(context);
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }
}
