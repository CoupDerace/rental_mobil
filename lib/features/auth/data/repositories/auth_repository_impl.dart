import '../../domain/entities/auth.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasource/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource datasource;

  AuthRepositoryImpl(this.datasource);

  @override
  Future<AuthEntity> login({
    required String email,
    required String password,
  }) {
    return datasource.login(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> logout() {
    return datasource.logout();
  }

  @override
  Future<AuthEntity?> getCurrentUser() {
    return datasource.currentUser();
  }
}