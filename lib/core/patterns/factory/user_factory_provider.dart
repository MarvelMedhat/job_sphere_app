import 'user_factory.dart';
import 'applicant_factory.dart';
import 'company_factory.dart';

class UserFactoryProvider {
  static UserFactory getFactory(String role) {
    switch (role) {
      case 'applicant':
        return ApplicantFactory();
      case 'company':
        return CompanyFactory();
      default:
        throw Exception('Invalid user role');
    }
  }
}
