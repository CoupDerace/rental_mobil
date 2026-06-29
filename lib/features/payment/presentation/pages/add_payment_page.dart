import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/components/organism/app_scaffold.dart';
import '../../../../app/routes/injector.dart';
import '../providers/payment_provider.dart';
import '../widgets/payment_form.dart';

class AddPaymentPage extends StatelessWidget {
  const AddPaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => sl<PaymentProvider>(),
      child: AppScaffold(
        title: "Tambah Pembayaran Baru",
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: const PaymentForm(),
            ),
          ),
        ),
      ),
    );
  }
}
