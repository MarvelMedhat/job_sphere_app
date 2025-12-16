import '../../../data/model/user.dart';

class UserRepository {
  static final UserRepository _instance = UserRepository._internal();
  UserRepository._internal();
  static UserRepository get instance => _instance;

  final List<User> _users = [];

  // Null-safe lookup
  User? getUserById(String id) {
    try {
      return _users.firstWhere((u) => u.id == id);
    } catch (e) {
      return null;
    }
  }

  void addUser(User user) {
    // Avoid duplicate users
    if (_users.any((u) => u.id == user.id)) return;
    _users.add(user);
  }
}
