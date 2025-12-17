import '/data/model/user.dart';

class UserRepository {
  static final UserRepository _instance = UserRepository._internal();
  UserRepository._internal();
  static UserRepository get instance => _instance;

  final List<User> _users = [];

  void addUser(User user) {
    _users.add(user);
  }

  User? getUserById(String? id) {
    if (id == null) return null;
    try {
      return _users.firstWhere((u) => u.id == id);
    } catch (_) {
      return null;
    }
  }

  User? getUserByEmail(String email) {
    try {
      return _users.firstWhere((u) => u.email == email);
    } catch (_) {
      return null;
    }
  }
}
