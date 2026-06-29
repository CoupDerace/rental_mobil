import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/components/organism/app_scaffold.dart';
import '../../../../app/routes/injector.dart';
import '../../data/models/payment_model.dart';
import '../providers/payment_provider.dart';
import '../widgets/payment_form.dart';

class EditPaymentPage extends StatelessWidget {
  final PaymentModel? payment;
  const EditPaymentPage({super.key, this.payment});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => sl<PaymentProvider>(),
      child: AppScaffold(
        title: "Edit Pembayaran",
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: PaymentForm(payment: payment),
            ),
          ),
        ),
      ),
    );
  }
}
