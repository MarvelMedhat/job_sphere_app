import '../../../data/model/applicant.dart';
import '../../../data/model/user.dart';
import 'user_factory.dart';

class ApplicantFactory implements UserFactory {
  @override
  User createUser({
    required String id,
    required String email,
    required String name,
    required String password,
    required String phone,
  }) {
    return Applicant(
      id: id,
      name: name,
      email: email,
      phone: phone,
      password: password,
      savedJobs: [],
    );
  }
}
