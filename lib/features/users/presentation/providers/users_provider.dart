import 'package:flutter/material.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/add_user.dart';
import '../../domain/usecases/delete_user.dart';
import '../../domain/usecases/get_users.dart';
import '../../domain/usecases/search_user.dart';
import '../../domain/usecases/update_user.dart';

class UsersProvider extends ChangeNotifier {
  final GetUsers getUsersUseCase;
  final AddUser addUserUseCase;
  final UpdateUser updateUserUseCase;
  final DeleteUser deleteUserUseCase;
  final SearchUser searchUserUseCase;

  UsersProvider({
    required this.getUsersUseCase,
    required this.addUserUseCase,
    required this.updateUserUseCase,
    required this.deleteUserUseCase,
    required this.searchUserUseCase,
  });

  final searchController = TextEditingController();

  List<User> _usersList = [];
  bool _loading = false;
  String? _error;

  List<User> get usersList => _usersList;
  bool get loading => _loading;
  String? get error => _error;

  List<User> get filteredUsers {
    if (searchController.text.isEmpty) {
      return _usersList;
    }

    final keyword = searchController.text.toLowerCase();
    return _usersList.where((u) {
      return u.nama.toLowerCase().contains(keyword) ||
          u.email.toLowerCase().contains(keyword) ||
          u.role.toLowerCase().contains(keyword);
    }).toList();
  }

  void onSearchChanged(String query) {
    notifyListeners();
  }

  Future<void> fetchUsers() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      _usersList = await getUsersUseCase();
    } catch (e) {
      _error = e.toString();
    }

    _loading = false;
    notifyListeners();
  }

  Future<void> addUser(Map<String, dynamic> data) async {
    _loading = true;
    notifyListeners();
    try {
      final user = User(
        id: '',
        nama: data['nama'] ?? '',
        email: data['email'] ?? '',
        noHp: data['no_hp'] ?? '',
        role: data['role'] ?? 'operator',
        createdAt: DateTime.now(),
      );
      await addUserUseCase(user);
      await fetchUsers();
    } catch (e) {
      _loading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updateUser(String id, Map<String, dynamic> data) async {
    _loading = true;
    notifyListeners();
    try {
      final user = User(
        id: id,
        nama: data['nama'] ?? '',
        email: data['email'] ?? '',
        noHp: data['no_hp'] ?? '',
        role: data['role'] ?? 'operator',
        createdAt: DateTime.now(),
      );
      await updateUserUseCase(id, user);
      await fetchUsers();
    } catch (e) {
      _loading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> deleteUser(String id) async {
    _loading = true;
    notifyListeners();
    try {
      await deleteUserUseCase(id);
      await fetchUsers();
    } catch (e) {
      _loading = false;
      notifyListeners();
      rethrow;
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
