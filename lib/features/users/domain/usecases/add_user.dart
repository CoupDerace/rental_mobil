import '../entities/user.dart';
import '../repositories/user_repository.dart';

class AddUser {
  final UserRepository repository;

  AddUser(this.repository);

  Future<void> call(User user) {
    return repository.addUser(user);
  }
}
