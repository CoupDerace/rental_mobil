import 'package:flutter/material.dart';

import '../../../../core/components/organism/app_scaffold.dart';
import '../widgets/payment_summary.dart';
import '../widgets/transaction_form.dart';

class EditTransactionPage extends StatelessWidget {
  const EditTransactionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: "Edit Transaksi",
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TransactionForm(),

            SizedBox(height: 30),

            PaymentSummary(
              subtotal: 700000,
              driverFee: 100000,
              discount: 50000,
            ),
          ],
        ),
      ),
    );
  }
}
