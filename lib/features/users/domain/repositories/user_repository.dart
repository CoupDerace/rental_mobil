import '../entities/user.dart';

abstract class UserRepository {
  Future<List<User>> getUsers();
  Future<void> addUser(User user);
  Future<void> updateUser(String id, User user);
  Future<void> deleteUser(String id);
  Future<List<User>> searchUsers(String query);
}
