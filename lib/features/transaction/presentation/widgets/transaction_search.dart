import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rental_mobil/features/transaction/presentation/providers/transaction_provider.dart';

class TransactionSearch extends StatelessWidget {
  const TransactionSearch({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: context.read<TransactionsProvider>().searchController,
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.search),
        hintText: "Cari transaksi...",
      ),
      onChanged: (_) {
        context.read<TransactionsProvider>().refresh();
      },
    );
  }
}
