import '/core/patterns/singleton/UserRepository.dart';
import '../../core/patterns/facade/auth_facade.dart';
import '../../data/model/user.dart';

class AuthController {
  final AuthFacade _authFacade = AuthFacade();
  final UserRepository _userRepo = UserRepository.instance;
  

  void login({
    required String role,
    required String email,
    required String password,
  }) {
    _authFacade.login(
      role: role,
      email: email,
       password: password,
    );
  }

  User? get currentUser => _authFacade.getCurrentUser();

  User? getUserByEmail(String email) {
    return _userRepo.getUserByEmail(email);
  }
  
   void logout() {
    _authFacade.logout();
  }
}
