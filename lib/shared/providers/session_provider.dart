import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user_model.dart';

final sessionProvider =
StateProvider<UserModel?>(
  (ref) => null,
);