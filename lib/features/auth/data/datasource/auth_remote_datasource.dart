abstract class AuthRemoteDatasource {
  Future<void> login({required String email, required String password});

  Future<void> logout();
}
