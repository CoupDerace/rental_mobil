import '../entities/user.dart';
import '../repositories/user_repository.dart';

class SearchUser {
  final UserRepository repository;

  SearchUser(this.repository);

  Future<List<User>> call(String query) {
    return repository.searchUsers(query);
  }
}
