import 'package:flutter/material.dart';

class PaymentSummary extends StatelessWidget {
  final int subtotal;
  final int driverFee;
  final int discount;

  const PaymentSummary({
    super.key,
    required this.subtotal,
    required this.driverFee,
    required this.discount,
  });

  @override
  Widget build(BuildContext context) {
    final total = subtotal + driverFee - discount;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                const Text("Subtotal"),
                const Spacer(),
                Text("Rp $subtotal"),
              ],
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                const Text("Driver"),
                const Spacer(),
                Text("Rp $driverFee"),
              ],
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                const Text("Diskon"),
                const Spacer(),
                Text("- Rp $discount"),
              ],
            ),

            const Divider(),

            Row(
              children: [
                const Text(
                  "Total",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),

                const Spacer(),

                Text(
                  "Rp $total",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
