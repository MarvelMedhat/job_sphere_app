import '../../../data/model/user.dart';

abstract class UserFactory {
  User createUser({
    required String id,
    required String email,
    required String name,
    required String password,
    required String phone,
  });
}
