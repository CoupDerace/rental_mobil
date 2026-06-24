import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/transaction_provider.dart';
import 'transaction_card.dart';

class TransactionList extends StatelessWidget {
  const TransactionList({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TransactionsProvider>();

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: provider.filteredTransactions.length,
      itemBuilder: (_, index) {
        return TransactionCard(
          transaction: provider.filteredTransactions[index],
        );
      },
    );
  }
}
