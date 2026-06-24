import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rental_mobil/app/routes/app.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app/config/supabase_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (SupabaseConfig.isConfigured) {
    await Supabase.initialize(
      url: SupabaseConfig.url,
      publishableKey: SupabaseConfig.anonKey,
    );
  } else {
    // Supabase not configured; skip initialization in non-production environments.
    // ignore: avoid_print
    print('Supabase not configured; skipping initialization.');
  }

  runApp(const ProviderScope(child: RentalMobilApp()));
}
