import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/components/organism/app_scaffold.dart';
import '../providers/transaction_provider.dart';
import '../widgets/transaction_list.dart';
import '../widgets/transaction_search.dart';

class TransactionsPage extends StatelessWidget {
  const TransactionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TransactionsProvider()..fetchTransactions(),
      child: AppScaffold(
        title: "Transaksi Rental",
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.add),
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: const [
            TransactionSearch(),

            SizedBox(height: 20),

            TransactionList(),
          ],
        ),
      ),
    );
  }
}
