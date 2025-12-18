import 'package:flutter_application_1/core/patterns/singleton/UserRepository.dart';
import '../../patterns/factory/user_factory.dart';
import '../../patterns/factory/user_factory_provider.dart';
import '../../patterns/singleton/auth_service.dart';
import '../../../data/model/user.dart';

class AuthFacade {
  
  final AuthService _authService = AuthService.instance;

  void login({
    required String role,
    required String email,
    required String password,
  }) {
    final existingUser = UserRepository.instance.getUserByEmail(email);

    if (existingUser == null) {
      throw Exception("User not registered");
    }

    if (existingUser.role != role) {
      throw Exception("Role mismatch");
    }

    _authService.login(existingUser);
  }

  void register({
    required String role,
    required String id,
    required String name,
    required String email,
    required String password,
    required String phone,
  }) {
    
    UserFactory factory = UserFactoryProvider.getFactory(role);

  
    User user = factory.createUser(
      id: id,
      name: name,
      email: email,
      phone: phone,
      password: password,
    );


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
}) {
  final user = _authService.currentUser;
  if (user != null) {
    user.name = name;
    user.email = email;
    user.phone = phone;
    
    UserRepository.instance.updateUser(user);
  }
}
}
