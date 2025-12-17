import '../../../data/model/user.dart';

class AuthService {
  // Lazy initialization - instance is null until first access
  static AuthService? _instance;
  
  // Private constructor
  AuthService._internal();

  // Lazy initialization getter - creates instance only when first called
  static AuthService get instance {
    if (_instance == null) {
      _instance = AuthService._internal();
    }
    return _instance!;
  }

  User? _currentUser;

  void login(User user) {
    _currentUser = user;
  }

  User? get currentUser => _currentUser;

  void logout() {
    _currentUser = null;
  }

  void register(User user) {}
}
