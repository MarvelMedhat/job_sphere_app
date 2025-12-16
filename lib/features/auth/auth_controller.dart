import '../../core/patterns/facade/auth_facade.dart';
import '../../data/model/user.dart';

class AuthController {
  final AuthFacade _authFacade = AuthFacade();

  void login({
    required String role,
    required String email,
    required String name,
  }) {
    _authFacade.login(
      role: role,
      id: DateTime.now().toString(),
      email: email,
      name: name, password: '',
    );
  }

  User? get currentUser => _authFacade.getCurrentUser();
  
   void logout() {
    _authFacade.logout();
  }
}
