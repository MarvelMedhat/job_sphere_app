import '../../../data/model/user.dart';

class UserRepository {
  // Lazy initialization - instance is null until first access
  static UserRepository? _instance;

  // Private constructor
  UserRepository._internal();

  // Lazy initialization getter - creates instance only when first called
  static UserRepository get instance {
    if (_instance == null) {
      _instance = UserRepository._internal();
    }
    return _instance!;
  }

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

  void updateUser(User user) {
    final index = _users.indexWhere((u) => u.id == user.id);
    if (index != -1) {
      _users[index] = user;
    }
  }

  /// Removes a job from all users' saved jobs
  void removeJobFromAllUsers(String jobId) {
    for (var user in _users) {
      user.savedJobs.remove(jobId);
    }
  }

  /// Public getter for all users (read-only)
  List<User> get users => List.unmodifiable(_users);
}
