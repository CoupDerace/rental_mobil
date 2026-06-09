import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:rental_mobil/core/theme/app_theme.dart';
import 'package:rental_mobil/core/utils/formatters.dart';
import 'package:rental_mobil/features/auth/data/models/car_model.dart';

class OwnerDashboardScreen extends StatefulWidget {
  const OwnerDashboardScreen({super.key});

  @override
  State<OwnerDashboardScreen> createState() => _OwnerDashboardScreenState();
}

class _OwnerDashboardScreenState extends State<OwnerDashboardScreen> {
  DateTime _startDate = DateTime(2026, 6, 1);
  DateTime _endDate = DateTime(2026, 6, 30);

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
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Owner Dashboard', style: textTheme.headlineMedium),
                  const SizedBox(height: 4),
                  Text(
                    'Ringkasan kinerja bisnis MULTI RENTCAR — Juni 2026',
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _DateChip(
                    label: Formatters.dateShort(_startDate),
                    onTap: () => _pickDate(true),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Text('—',
                        style: TextStyle(
                            color: colorScheme.onSurfaceVariant)),
                  ),
                  _DateChip(
                    label: Formatters.dateShort(_endDate),
                    onTap: () => _pickDate(false),
                  ),
                  const SizedBox(width: 8),
                  FilledButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.filter_alt_rounded, size: 16),
                    label: const Text('Filter'),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),

          // KPI Cards
          _OwnerKpiGrid(),
          const SizedBox(height: 24),

          // Charts Row 1: Area + Pie
          LayoutBuilder(builder: (context, constraints) {
            final isWide = constraints.maxWidth > 700;
            if (isWide) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      flex: 2, child: _RevenueAreaChart()),
                  const SizedBox(width: 16),
                  Expanded(child: _CarStatusPieChart()),
                ],
              );
            }
            return Column(
              children: [
                _RevenueAreaChart(),
                const SizedBox(height: 16),
                _CarStatusPieChart(),
              ],
            );
          }),
          const SizedBox(height: 16),

          // Charts Row 2: Bar + Top Cars
          LayoutBuilder(builder: (context, constraints) {
            final isWide = constraints.maxWidth > 700;
            if (isWide) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _MonthlyBarChart()),
                  const SizedBox(width: 16),
                  Expanded(child: _TopCarsProgress()),
                ],
              );
            }
            return Column(
              children: [
                _MonthlyBarChart(),
                const SizedBox(height: 16),
                _TopCarsProgress(),
              ],
            );
          }),
          const SizedBox(height: 16),

          // Notifications + Reports
          LayoutBuilder(builder: (context, constraints) {
            final isWide = constraints.maxWidth > 700;
            if (isWide) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _RecentNotificationsCard()),
                  const SizedBox(width: 16),
                  Expanded(child: _DownloadReportsCard()),
                ],
              );
            }
            return Column(
              children: [
                _RecentNotificationsCard(),
                const SizedBox(height: 16),
                _DownloadReportsCard(),
              ],
            );
          }),
        ],
      ),
    );
  }
}

class _DateChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _DateChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: colorScheme.outline),
          borderRadius: BorderRadius.circular(8),
          color: colorScheme.surfaceContainerHighest,
        ),
        child: Text(label,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: colorScheme.onSurface)),
      ),
    );
  }
}

// ─── Owner KPI Grid ────────────────────────────────────────────────────────

class _OwnerKpiGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final successColor = AppTheme.successColor(context);
    final warningColor = AppTheme.warningColor(context);

    final items = [
      _OwnerKpi(
        title: 'Total Pendapatan Bulan Ini',
        value: Formatters.currencyShort(24800000),
        change: '+16.4%',
        isUp: true,
        icon: Icons.attach_money_rounded,
        iconBg: colorScheme.primary.withOpacity(0.12),
        iconColor: colorScheme.primary,
        changeColor: successColor,
      ),
      _OwnerKpi(
        title: 'Total Armada',
        value: '48 Mobil',
        change: '+2 unit',
        isUp: true,
        icon: Icons.directions_car_rounded,
        iconBg: const Color(0xFF3B82F6).withOpacity(0.12),
        iconColor: const Color(0xFF3B82F6),
        changeColor: successColor,
      ),
      _OwnerKpi(
        title: 'Total Transaksi',
        value: '68',
        change: '+11.5%',
        isUp: true,
        icon: Icons.bar_chart_rounded,
        iconBg: successColor.withOpacity(0.12),
        iconColor: successColor,
        changeColor: successColor,
      ),
      _OwnerKpi(
        title: 'Pelanggan Aktif',
        value: '124',
        change: '+8 pelanggan',
        isUp: true,
        icon: Icons.people_rounded,
        iconBg: warningColor.withOpacity(0.12),
        iconColor: warningColor,
        changeColor: successColor,
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
          childAspectRatio: 1.4,
        ),
        itemCount: items.length,
        itemBuilder: (context, i) => _OwnerKpiCard(data: items[i]),
      );
    });
  }
}

class _OwnerKpi {
  final String title;
  final String value;
  final String change;
  final bool isUp;
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final Color changeColor;

  const _OwnerKpi({
    required this.title,
    required this.value,
    required this.change,
    required this.isUp,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.changeColor,
  });
}

class _OwnerKpiCard extends StatelessWidget {
  final _OwnerKpi data;

  const _OwnerKpiCard({required this.data});

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
                  child:
                      Icon(data.icon, size: 20, color: data.iconColor),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      data.isUp
                          ? Icons.arrow_upward_rounded
                          : Icons.arrow_downward_rounded,
                      size: 12,
                      color: data.changeColor,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      data.change,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: data.changeColor,
                      ),
                    ),
                  ],
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
                  maxLines: 2,
                ),
                const SizedBox(height: 2),
                Text(
                  data.value,
                  style: textTheme.titleLarge?.copyWith(
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

// ─── Revenue Area Chart ────────────────────────────────────────────────────

class _RevenueAreaChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final data = SampleData.revenueData;

    final revenueSpots = data.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(), e.value.revenue / 1000000);
    }).toList();
    final targetSpots = data.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(), e.value.target / 1000000);
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
                Text('Pendapatan vs Target (6 Bulan)',
                    style: textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _LegendDot(
                    color: colorScheme.primary, label: 'Pendapatan'),
                const SizedBox(width: 16),
                _LegendDot(
                    color: colorScheme.onSurfaceVariant,
                    label: 'Target',
                    isDashed: true),
              ],
            ),
            const SizedBox(height: 16),
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
                      spots: revenueSpots,
                      isCurved: true,
                      color: colorScheme.primary,
                      barWidth: 2.5,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: colorScheme.primary.withOpacity(0.1),
                      ),
                    ),
                    LineChartBarData(
                      spots: targetSpots,
                      isCurved: true,
                      color: colorScheme.onSurfaceVariant.withOpacity(0.5),
                      barWidth: 1.5,
                      dashArray: [5, 5],
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(show: false),
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

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;
  final bool isDashed;

  const _LegendDot({
    required this.color,
    required this.label,
    this.isDashed = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 20,
          height: 3,
          decoration: BoxDecoration(
            color: isDashed ? Colors.transparent : color,
            border: isDashed
                ? Border(bottom: BorderSide(color: color, width: 2))
                : null,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

// ─── Car Status Pie Chart ──────────────────────────────────────────────────

class _CarStatusPieChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final data = SampleData.carStatusCounts;

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
                Text('Status Armada', style: textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 180,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 50,
                  sections: data.map((item) {
                    return PieChartSectionData(
                      value: item.count.toDouble(),
                      color: Color(item.colorValue),
                      radius: 36,
                      showTitle: false,
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 12),
            ...data.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(item.colorValue),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(item.label,
                              style: textTheme.bodySmall),
                        ],
                      ),
                      Text(
                        '${item.count} unit',
                        style: textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

// ─── Monthly Transactions Bar Chart ───────────────────────────────────────

class _MonthlyBarChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final data = SampleData.monthlyTransactions;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.bar_chart_rounded,
                    size: 18, color: colorScheme.primary),
                const SizedBox(width: 8),
                Text('Jumlah Transaksi per Bulan',
                    style: textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 80,
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
                  barGroups: data.asMap().entries.map((e) {
                    return BarChartGroupData(
                      x: e.key,
                      barRods: [
                        BarChartRodData(
                          toY: e.value.count.toDouble(),
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

// ─── Top Cars Progress Bars ────────────────────────────────────────────────

class _TopCarsProgress extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final cars = SampleData.topCars;
    final maxRentals = cars.first.rentals.toDouble();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.emoji_events_rounded,
                    size: 18, color: colorScheme.primary),
                const SizedBox(width: 8),
                Text('Top 5 Mobil Paling Laris',
                    style: textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: 20),
            ...cars.asMap().entries.map((entry) {
              final i = entry.key;
              final car = entry.value;
              final ratio = car.rentals / maxRentals;

              return Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: Row(
                  children: [
                    SizedBox(
                      width: 20,
                      child: Text(
                        '${i + 1}.',
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  car.name,
                                  style: textTheme.bodyMedium,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${car.rentals}x',
                                style: textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: ratio,
                              backgroundColor:
                                  colorScheme.surfaceContainerHighest,
                              valueColor: AlwaysStoppedAnimation(
                                  colorScheme.primary),
                              minHeight: 8,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 80,
                      child: Text(
                        Formatters.currencyShort(car.revenue),
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

// ─── Recent Notifications ──────────────────────────────────────────────────

class _RecentNotificationsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final notifs = SampleData.notifications.take(5).toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.notifications_rounded,
                    size: 18, color: colorScheme.primary),
                const SizedBox(width: 8),
                Text('Notifikasi Terbaru', style: textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: 16),
            ...notifs.map((notif) => _NotifItem(notif: notif)),
          ],
        ),
      ),
    );
  }
}

class _NotifItem extends StatelessWidget {
  final AppNotification notif;

  const _NotifItem({required this.notif});

  Color _dotColor(BuildContext context) {
    switch (notif.type) {
      case NotifType.success:
        return AppTheme.successColor(context);
      case NotifType.warning:
        return AppTheme.warningColor(context);
      case NotifType.error:
        return AppTheme.errorColor(context);
      case NotifType.info:
        return Theme.of(context).colorScheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final dotColor = _dotColor(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest.withOpacity(0.5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: dotColor,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(notif.message, style: textTheme.bodySmall),
                  const SizedBox(height: 4),
                  Text(
                    notif.time,
                    style: textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Download Reports ──────────────────────────────────────────────────────

class _DownloadReportsCard extends StatefulWidget {
  @override
  State<_DownloadReportsCard> createState() => _DownloadReportsCardState();
}

class _DownloadReportsCardState extends State<_DownloadReportsCard> {
  DateTime _from = DateTime(2026, 6, 1);
  DateTime _to = DateTime(2026, 6, 30);

  static const _reportTypes = [
    _ReportType(title: 'Laporan Pendapatan', description: 'Pendapatan per periode'),
    _ReportType(title: 'Laporan Rental', description: 'Riwayat transaksi rental'),
    _ReportType(title: 'Laporan Armada', description: 'Status dan kondisi mobil'),
    _ReportType(title: 'Laporan Pelanggan', description: 'Data & aktivitas pelanggan'),
  ];

  Future<void> _pick(bool isFrom) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isFrom ? _from : _to,
      firstDate: DateTime(2024),
      lastDate: DateTime(2027),
    );
    if (picked != null) {
      setState(() => isFrom ? _from = picked : _to = picked);
    }
  }

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
                Icon(Icons.description_rounded,
                    size: 18, color: colorScheme.primary),
                const SizedBox(width: 8),
                Text('Unduh Laporan', style: textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: 16),

            // Date range
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Dari Tanggal',
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          )),
                      const SizedBox(height: 6),
                      InkWell(
                        onTap: () => _pick(true),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                            border: Border.all(color: colorScheme.outline),
                            borderRadius: BorderRadius.circular(8),
                            color: colorScheme.surfaceContainerHighest,
                          ),
                          child: Text(Formatters.dateShort(_from),
                              style: textTheme.bodySmall),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Sampai Tanggal',
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          )),
                      const SizedBox(height: 6),
                      InkWell(
                        onTap: () => _pick(false),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                            border: Border.all(color: colorScheme.outline),
                            borderRadius: BorderRadius.circular(8),
                            color: colorScheme.surfaceContainerHighest,
                          ),
                          child: Text(Formatters.dateShort(_to),
                              style: textTheme.bodySmall),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Report type rows
            ..._reportTypes.map((report) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: colorScheme.outline),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(report.title,
                                  style: textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  )),
                              Text(report.description,
                                  style: textTheme.bodySmall?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  )),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Row(
                          children: [
                            OutlinedButton.icon(
                              onPressed: () => _showSnackBar(
                                  context, '${report.title} (PDF) diunduh'),
                              icon: const Icon(Icons.picture_as_pdf_rounded,
                                  size: 14),
                              label: const Text('PDF'),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 8),
                                minimumSize: Size.zero,
                                tapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                textStyle: const TextStyle(fontSize: 12),
                              ),
                            ),
                            const SizedBox(width: 6),
                            OutlinedButton.icon(
                              onPressed: () => _showSnackBar(
                                  context, '${report.title} (Excel) diunduh'),
                              icon: const Icon(Icons.table_chart_rounded,
                                  size: 14),
                              label: const Text('Excel'),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 8),
                                minimumSize: Size.zero,
                                tapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                textStyle: const TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), duration: const Duration(seconds: 2)),
    );
  }
}

class _ReportType {
  final String title;
  final String description;

  const _ReportType({required this.title, required this.description});
}
