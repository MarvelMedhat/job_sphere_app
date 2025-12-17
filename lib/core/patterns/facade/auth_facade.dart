import 'package:flutter_application_1/core/patterns/singleton/UserRepository.dart';
import '../../patterns/factory/user_factory.dart';
import '../../patterns/factory/user_factory_provider.dart';
import '../../patterns/singleton/auth_service.dart';
import '../../../data/model/user.dart';

/// Facade for Authentication
/// Simplifies authentication and user management operations
/// Following the Facade pattern: aggregates multiple subsystems
/// (AuthService, UserRepository, UserFactoryProvider)
class AuthFacade {
  // Subsystem: Auth Service
  final AuthService _authService = AuthService.instance;

  /// LOGIN
  void login({
    required String role,
    required String email,
    required String password,
  }) {
    final existingUser = UserRepository.instance.getUserByEmail(email);

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

  /// REGISTER
  void register({
    required String role,
    required String id,
    required String name,
    required String email,
    required String password,
    required String phone,
  }) {
    // ✅ GET CORRECT FACTORY
    UserFactory factory = UserFactoryProvider.getFactory(role);

    // ✅ CREATE USER (NO static call)
    User user = factory.createUser(
      id: id,
      name: name,
      email: email,
      phone: phone,
      password: password,
    );

    // ✅ REGISTER & SAVE
    _authService.register(user);
    UserRepository.instance.addUser(user);
  }

  User? getCurrentUser() => _authService.currentUser;

  void logout() {
    _authService.logout();
  }

  void updateProfile({
    required String name,
    required String email,
    required String phone,
  }) {}
}
