import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasource/user_remote_datasource.dart';
import '../models/user_model.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<User>> getUsers() async {
    return await remoteDataSource.getUsers();
  }

  @override
  Future<void> addUser(User user) async {
    final model = UserModel(
      id: user.id,
      authUserId: user.authUserId,
      nama: user.nama,
      email: user.email,
      role: user.role,
      noHp: user.noHp,
      createdAt: user.createdAt,
    );
    await remoteDataSource.addUser(model);
  }

  @override
  Future<void> updateUser(String id, User user) async {
    final model = UserModel(
      id: user.id,
      authUserId: user.authUserId,
      nama: user.nama,
      email: user.email,
      role: user.role,
      noHp: user.noHp,
      createdAt: user.createdAt,
    );
    await remoteDataSource.updateUser(id, model);
  }

  @override
  Future<void> deleteUser(String id) async {
    await remoteDataSource.deleteUser(id);
  }

  @override
  Future<List<User>> searchUsers(String query) async {
    return await remoteDataSource.searchUsers(query);
  }
}
