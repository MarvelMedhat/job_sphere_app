import '../../../data/model/user.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  AuthService._internal();

  static AuthService get instance => _instance;

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
