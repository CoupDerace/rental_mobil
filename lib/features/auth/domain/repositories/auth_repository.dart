
import 'package:rental_mobil/features/auth/domain/entities/auth.dart';

abstract class AuthRepository{

Future<AuthEntity> login({

required String email,

required String password,

});

Future<void> logout();

}