import '../../patterns/factory/user_factory.dart';
import '../../patterns/singleton/auth_service.dart';
import '../../patterns/singleton/UserRepository.dart';
import '../../../data/model/user.dart';

class AuthFacade {
  final AuthService _authService = AuthService.instance;

  /// Login existing user
  void login({
  required String role,
  required String email,
  required String password,
}) {
  final existingUser =
      UserRepository.instance.getUserByEmail(email);

  // ❌ NOT REGISTERED
  if (existingUser == null) {
    throw Exception("User not registered");
  }

  // ❌ WRONG ROLE
  if (existingUser.role != role) {
    throw Exception("Role mismatch");
  }

 

  // ✅ LOGIN SUCCESS
  _authService.login(existingUser);
}

  /// Register new user
  void register({
    required String role,
    required String id,
    required String name,
    required String email,
    required String password,
    required String phone,
  }) {
    User user = UserFactory.createUser(
      role: role,
      id: id,
      email: email,
      name: name,
      password: password,
      phone: phone,
    );

    _authService.register(user);

    // ✅ SAVE USER
    UserRepository.instance.addUser(user);
  }

  User? getCurrentUser() => _authService.currentUser;

  void logout() {
    _authService.logout();
  }

  void updateProfile({required String name, required String email, required String phone}) {}
}
