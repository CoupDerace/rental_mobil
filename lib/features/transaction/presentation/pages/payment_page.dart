import 'package:flutter/material.dart';

import '../../../../core/components/atoms/app_button.dart';
import '../../../../core/components/organism/app_scaffold.dart';
import '../widgets/payment_summary.dart';

class PaymentPage extends StatelessWidget {
  const PaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "Pembayaran",
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const PaymentSummary(
            subtotal: 700000,
            driverFee: 100000,
            discount: 50000,
          ),

          const SizedBox(height: 30),

          AppButton(label: "Bayar Sekarang", onPressed: () {}),
        ],
      ),
    );
  }
}
