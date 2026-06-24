import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rental_mobil/features/services/presentation/widgets/services_card.dart';

import '../providers/services_provider.dart';

class ServiceList extends StatelessWidget {
  const ServiceList({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ServicesProvider>();

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: provider.filteredServices.length,
      itemBuilder: (_, index) {
        return ServiceCard(service: provider.filteredServices[index]);
      },
    );
  }
}
