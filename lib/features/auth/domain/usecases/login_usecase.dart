import 'package:rental_mobil/features/auth/domain/entities/auth.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  const LoginUseCase(this.repository);

  Future<AuthEntity> call({required String email, required String password}) {
    return repository.login(email: email, password: password);
  }
}
