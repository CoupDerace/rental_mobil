import 'package:flutter/material.dart';
import 'package:rental_mobil/core/theme/app_theme.dart';
import 'package:rental_mobil/core/utils/formatters.dart';
import 'package:rental_mobil/features/auth/data/models/car_model.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  String _searchQuery = '';
  TransactionStatus? _filterStatus;

  List<Transaction> get _filtered {
    return SampleData.transactions.where((t) {
      final matchesSearch = t.customerName
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          t.carName.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesStatus =
          _filterStatus == null || t.status == _filterStatus;
      return matchesSearch && matchesStatus;
    }).toList();
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
          Text('Transaksi', style: textTheme.headlineMedium),
          const SizedBox(height: 4),
          Text(
            'Daftar semua transaksi rental kendaraan',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),

          // Filters
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Cari customer atau mobil...',
                    prefixIcon: const Icon(Icons.search_rounded),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () =>
                                setState(() => _searchQuery = ''),
                          )
                        : null,
                  ),
                  onChanged: (v) => setState(() => _searchQuery = v),
                ),
              ),
              const SizedBox(width: 12),
              _StatusFilterButton(
                selected: _filterStatus,
                onChanged: (s) => setState(() => _filterStatus = s),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Status pills
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _FilterChip(
                  label: 'Semua',
                  isSelected: _filterStatus == null,
                  onTap: () => setState(() => _filterStatus = null),
                ),
                const SizedBox(width: 8),
                ...TransactionStatus.values.map((s) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: _FilterChip(
                        label: s.label,
                        isSelected: _filterStatus == s,
                        onTap: () =>
                            setState(() => _filterStatus = s),
                        status: s,
                      ),
                    )),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Table
          Card(
            child: Column(
              children: [
                // Table header
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12)),
                  ),
                  child: Row(
                    children: [
                      Text('#',
                          style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant)),
                      const SizedBox(width: 8),
                      Expanded(
                          flex: 2,
                          child: Text('Customer',
                              style: textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant))),
                      Expanded(
                          flex: 2,
                          child: Text('Mobil',
                              style: textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant))),
                      Expanded(
                          child: Text('Periode',
                              style: textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant))),
                      Expanded(
                          child: Text('Total',
                              style: textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant))),
                      SizedBox(
                          width: 80,
                          child: Text('Status',
                              style: textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant))),
                    ],
                  ),
                ),

                // Rows
                if (_filtered.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(40),
                    child: Column(
                      children: [
                        Icon(Icons.receipt_long_rounded,
                            size: 48,
                            color: colorScheme.onSurfaceVariant),
                        const SizedBox(height: 12),
                        Text(
                          'Tidak ada transaksi ditemukan',
                          style: textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant),
                        ),
                      ],
                    ),
                  )
                else
                  ..._filtered.map((t) => _TransactionRow(tx: t)),
              ],
            ),
          ),

          const SizedBox(height: 12),
          Text(
            'Menampilkan ${_filtered.length} dari ${SampleData.transactions.length} transaksi',
            style: textTheme.bodySmall
                ?.copyWith(color: colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final TransactionStatus? status;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.status,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.primary.withOpacity(0.12)
              : Colors.transparent,
          border: Border.all(
            color: isSelected ? colorScheme.primary : colorScheme.outline,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: isSelected
                ? colorScheme.primary
                : colorScheme.onSurfaceVariant,
            fontWeight:
                isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class _StatusFilterButton extends StatelessWidget {
  final TransactionStatus? selected;
  final void Function(TransactionStatus?) onChanged;

  const _StatusFilterButton(
      {required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<TransactionStatus?>(
      icon: Icon(Icons.filter_list_rounded,
          color: Theme.of(context).colorScheme.primary),
      tooltip: 'Filter status',
      onSelected: onChanged,
      itemBuilder: (_) => [
        const PopupMenuItem(value: null, child: Text('Semua Status')),
        ...TransactionStatus.values.map(
          (s) => PopupMenuItem(value: s, child: Text(s.label)),
        ),
      ],
    );
  }
}

class _TransactionRow extends StatelessWidget {
  final Transaction tx;

  const _TransactionRow({required this.tx});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: () => _showDetail(context),
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
                color: colorScheme.outline.withOpacity(0.5), width: 1),
          ),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 24,
              child: Text(
                '#${tx.id}',
                style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(tx.customerName,
                      style: textTheme.bodyMedium
                          ?.copyWith(fontWeight: FontWeight.w600)),
                  if (tx.driverName != null)
                    Text('Supir: ${tx.driverName}',
                        style: textTheme.bodySmall),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(tx.carName, style: textTheme.bodyMedium),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(Formatters.dateShort(tx.startDate),
                      style: textTheme.bodySmall),
                  Text(Formatters.dateShort(tx.endDate),
                      style: textTheme.bodySmall),
                  Text('${tx.durationDays} hari',
                      style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant)),
                ],
              ),
            ),
            Expanded(
              child: Text(
                Formatters.currencyShort(tx.totalPrice),
                style: textTheme.bodyMedium
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(
              width: 80,
              child: _TxStatusBadge(status: tx.status),
            ),
          ],
        ),
      ),
    );
  }

  void _showDetail(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _TransactionDetailSheet(tx: tx),
    );
  }
}

class _TxStatusBadge extends StatelessWidget {
  final TransactionStatus status;

  const _TxStatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;

    switch (status) {
      case TransactionStatus.completed:
        bg = AppTheme.successColor(context).withOpacity(0.15);
        fg = AppTheme.successColor(context);
        break;
      case TransactionStatus.active:
        bg = Theme.of(context).colorScheme.primary.withOpacity(0.12);
        fg = Theme.of(context).colorScheme.primary;
        break;
      case TransactionStatus.pending:
        bg = AppTheme.warningColor(context).withOpacity(0.15);
        fg = AppTheme.warningColor(context);
        break;
      case TransactionStatus.cancelled:
        bg = AppTheme.errorColor(context).withOpacity(0.12);
        fg = AppTheme.errorColor(context);
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.label,
        style:
            TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: fg),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _TransactionDetailSheet extends StatelessWidget {
  final Transaction tx;

  const _TransactionDetailSheet({required this.tx});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Text('Detail Transaksi #${tx.id}',
              style: textTheme.headlineSmall),
          const SizedBox(height: 20),
          _DetailRow(
              label: 'Customer', value: tx.customerName),
          _DetailRow(label: 'Mobil', value: tx.carName),
          if (tx.driverName != null)
            _DetailRow(label: 'Supir', value: tx.driverName!),
          _DetailRow(
              label: 'Mulai',
              value: Formatters.date(tx.startDate)),
          _DetailRow(
              label: 'Selesai',
              value: Formatters.date(tx.endDate)),
          _DetailRow(
              label: 'Durasi',
              value: '${tx.durationDays} hari'),
          _DetailRow(
              label: 'Total',
              value: Formatters.currency(tx.totalPrice)),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tutup'),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: textTheme.bodyMedium
                  ?.copyWith(color: colorScheme.onSurfaceVariant)),
          Text(value,
              style: textTheme.bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
