import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final locator = GetIt.instance;

Future<void> setupInjector() async {
  // Daftarkan client Supabase ke dalam locator GetIt
  locator.registerSingleton<SupabaseClient>(Supabase.instance.client);
  
  // Nanti repositories & usecases didaftarkan berurutan di bawah sini
}