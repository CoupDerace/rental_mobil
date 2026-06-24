import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/components/organism/app_scaffold.dart';
import '../providers/services_provider.dart';
import '../widgets/services_list.dart';
import '../widgets/services_search.dart';


class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ServicesProvider(),
      child: AppScaffold(
        title: 'Data Servis',
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.add),
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: const [
            ServiceSearch(),

            SizedBox(height: 20),

            ServiceList(),
          ],
        ),
      ),
    );
  }
}
