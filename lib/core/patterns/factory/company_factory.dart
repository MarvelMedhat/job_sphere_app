import '../../../data/model/company.dart';
import '../../../data/model/user.dart';
import 'user_factory.dart';

class CompanyFactory implements UserFactory {
  @override
  User createUser({
    required String id,
    required String email,
    required String name,
    required String password,
    required String phone,
  }) {
    return Company(
      id: id,
      name: name,
      email: email,
      phone: phone,
      password: password,
      companyName: name,
    );
  }
}
