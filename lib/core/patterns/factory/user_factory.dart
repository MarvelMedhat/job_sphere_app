import '../../../data/model/applicant.dart';
import '../../../data/model/company.dart';
import '../../../data/model/user.dart';

class UserFactory {
  static User createUser({
    required String role,
    required String id,
    required String email,
    required String name,
    required String password,
    required String phone,
  }) {
    switch (role) {
      case 'applicant':
        return Applicant(
          id: id,
          name: name,
          email: email,
          phone: phone,
          password: password,
          savedJobs: [], // optional, can be omitted
        );
      case 'company':
        return Company(
          id: id,
          name: name,
          email: email,
          phone: phone,
          password: password,
          companyName: name,
        );
      default:
        throw Exception("Invalid user role");
    }
  }
}
