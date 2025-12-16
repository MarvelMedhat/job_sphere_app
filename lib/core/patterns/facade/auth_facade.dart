import '../../patterns/factory/user_factory.dart';
import '../../patterns/singleton/auth_service.dart';
import '../../../data/model/user.dart';

class AuthFacade {
  final AuthService _authService = AuthService.instance;

  /// Login existing user
  void login({
    required String role,
    required String id,
    required String email,
    required String password, required String name,
  }) {
    // For demo, create a user object with minimal info
    User user = UserFactory.createUser(
      role: role,
      id: id,
      email: email,
      name: '', // name can be fetched from stored user DB if needed
      password: password, phone: '',
    );
    _authService.login(user);
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
  }

  /// Get currently logged-in user
  User? getCurrentUser() => _authService.currentUser;

  /// Logout
  void logout() {
    _authService.logout();
  }

  void saveJobToProfile(String jobId) {
    final user = _authService.currentUser;
    if (user != null && !user.savedJobs.contains(jobId)) {
      user.savedJobs.add(jobId);
    }
  }

  void updateProfile({String? name, String? email, String? phone}) {
    final user = _authService.currentUser;
    if (user != null) {
      user.name = name ?? user.name;
      user.email = email ?? user.email;
      user.phone = phone ?? user.phone;
    }
  }
}
