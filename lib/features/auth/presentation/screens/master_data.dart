import 'package:flutter/material.dart';

class MasterDataScreen extends StatefulWidget {
  const MasterDataScreen({super.key});

  @override
  State<MasterDataScreen> createState() => _MasterDataScreenState();
}

class _MasterDataScreenState extends State<MasterDataScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Master Data', style: textTheme.headlineMedium),
                const SizedBox(height: 4),
                Text(
                  'Kelola data mobil, pelanggan, dan supir',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 20),
                TabBar(
                  controller: _tabController,
                  tabs: const [
                    Tab(icon: Icon(Icons.directions_car_rounded), text: 'Mobil'),
                    Tab(icon: Icon(Icons.people_rounded), text: 'Pelanggan'),
                    Tab(icon: Icon(Icons.person_pin_rounded), text: 'Supir'),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _TabContent(
                  searchQuery: _searchQuery,
                  onSearchChanged: (v) => setState(() => _searchQuery = v),
                  onAdd: _showAddDialog,
                  child: _CarsTable(searchQuery: _searchQuery),
                ),
                _TabContent(
                  searchQuery: _searchQuery,
                  onSearchChanged: (v) => setState(() => _searchQuery = v),
                  onAdd: _showAddDialog,
                  child: _CustomersTable(searchQuery: _searchQuery),
                ),
                _TabContent(
                  searchQuery: _searchQuery,
                  onSearchChanged: (v) => setState(() => _searchQuery = v),
                  onAdd: _showAddDialog,
                  child: _DriversTable(searchQuery: _searchQuery),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddDialog,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Tambah'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
    );
  }

  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Tambah Data'),
        content: const Text(
            'Form tambah data akan ditampilkan di sini sesuai tab aktif.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }
}

class _TabContent extends StatelessWidget {
  final String searchQuery;
  final void Function(String) onSearchChanged;
  final VoidCallback onAdd;
  final Widget child;

  const _TabContent({
    required this.searchQuery,
    required this.onSearchChanged,
    required this.onAdd,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Search bar
          TextField(
            decoration: InputDecoration(
              hintText: 'Cari...',
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () => onSearchChanged(''),
                    )
                  : null,
            ),
            onChanged: onSearchChanged,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Card(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: child,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Cars Table ────────────────────────────────────────────────────────────

class _CarsTable extends StatelessWidget {
  final String searchQuery;

  const _CarsTable({required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final filtered = SampleData.cars
        .where((c) =>
            c.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
            c.plate.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor: WidgetStatePropertyAll(
            colorScheme.surfaceContainerHighest),
        columnSpacing: 20,
        horizontalMargin: 16,
        columns: const [
          DataColumn(label: Text('Mobil')),
          DataColumn(label: Text('Tipe')),
          DataColumn(label: Text('Plat Nomor')),
          DataColumn(label: Text('Harga/Hari'), numeric: true),
          DataColumn(label: Text('Status')),
          DataColumn(label: Text('Aksi')),
        ],
        rows: filtered.map((car) {
          return DataRow(cells: [
            DataCell(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(car.name,
                      style: textTheme.bodyMedium
                          ?.copyWith(fontWeight: FontWeight.w600)),
                  Text(car.color, style: textTheme.bodySmall),
                ],
              ),
            ),
            DataCell(Text(car.type)),
            DataCell(Text(car.plate,
                style: const TextStyle(fontFamily: 'monospace'))),
            DataCell(Text(Formatters.currency(car.pricePerDay))),
            DataCell(_CarStatusChip(status: car.status)),
            DataCell(_ActionButtons(
              onEdit: () {},
              onDelete: () {},
            )),
          ]);
        }).toList(),
      ),
    );
  }
}

class _CarStatusChip extends StatelessWidget {
  final CarStatus status;

  const _CarStatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;

    switch (status) {
      case CarStatus.tersedia:
        bgColor = AppTheme.successColor(context).withOpacity(0.15);
        textColor = AppTheme.successColor(context);
        break;
      case CarStatus.disewa:
        bgColor = AppTheme.warningColor(context).withOpacity(0.15);
        textColor = AppTheme.warningColor(context);
        break;
      case CarStatus.servis:
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
            fontSize: 12, fontWeight: FontWeight.w600, color: textColor),
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ActionButtons({required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.edit_rounded, size: 18),
          onPressed: onEdit,
          color: colorScheme.primary,
          tooltip: 'Edit',
        ),
        IconButton(
          icon: const Icon(Icons.delete_rounded, size: 18),
          onPressed: () {
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('Hapus Data'),
                content:
                    const Text('Apakah Anda yakin ingin menghapus data ini?'),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Batal')),
                  FilledButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      onDelete();
                    },
                    style: FilledButton.styleFrom(
                        backgroundColor: colorScheme.error),
                    child: const Text('Hapus'),
                  ),
                ],
              ),
            );
          },
          color: colorScheme.error,
          tooltip: 'Hapus',
        ),
      ],
    );
  }
}

// ─── Customers Table ───────────────────────────────────────────────────────

class _CustomersTable extends StatelessWidget {
  final String searchQuery;

  const _CustomersTable({required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final filtered = SampleData.customers
        .where((c) =>
            c.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
            c.phone.contains(searchQuery))
        .toList();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor: WidgetStatePropertyAll(
            colorScheme.surfaceContainerHighest),
        columnSpacing: 20,
        horizontalMargin: 16,
        columns: const [
          DataColumn(label: Text('Nama')),
          DataColumn(label: Text('Telepon')),
          DataColumn(label: Text('Email')),
          DataColumn(label: Text('Alamat')),
          DataColumn(label: Text('Aksi')),
        ],
        rows: filtered.map((customer) {
          return DataRow(cells: [
            DataCell(Text(customer.name,
                style:
                    const TextStyle(fontWeight: FontWeight.w600))),
            DataCell(Text(customer.phone)),
            DataCell(Text(customer.email)),
            DataCell(Text(customer.address)),
            DataCell(_ActionButtons(onEdit: () {}, onDelete: () {})),
          ]);
        }).toList(),
      ),
    );
  }
}

// ─── Drivers Table ─────────────────────────────────────────────────────────

class _DriversTable extends StatelessWidget {
  final String searchQuery;

  const _DriversTable({required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final filtered = SampleData.drivers
        .where((d) =>
            d.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
            d.phone.contains(searchQuery))
        .toList();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor: WidgetStatePropertyAll(
            colorScheme.surfaceContainerHighest),
        columnSpacing: 20,
        horizontalMargin: 16,
        columns: const [
          DataColumn(label: Text('Nama')),
          DataColumn(label: Text('Telepon')),
          DataColumn(label: Text('SIM')),
          DataColumn(label: Text('Pengalaman')),
          DataColumn(label: Text('Status')),
          DataColumn(label: Text('Aksi')),
        ],
        rows: filtered.map((driver) {
          return DataRow(cells: [
            DataCell(Text(driver.name,
                style:
                    const TextStyle(fontWeight: FontWeight.w600))),
            DataCell(Text(driver.phone)),
            DataCell(Text(driver.license)),
            DataCell(Text(driver.experience)),
            DataCell(_DriverStatusChip(status: driver.status)),
            DataCell(_ActionButtons(onEdit: () {}, onDelete: () {})),
          ]);
        }).toList(),
      ),
    );
  }
}

class _DriverStatusChip extends StatelessWidget {
  final DriverStatus status;

  const _DriverStatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final isAvailable = status == DriverStatus.available;
    final color = isAvailable
        ? AppTheme.successColor(context)
        : AppTheme.warningColor(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.label,
        style: TextStyle(
            fontSize: 12, fontWeight: FontWeight.w600, color: color),
      ),
    );
  }
}
