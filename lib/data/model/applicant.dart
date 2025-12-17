import 'user.dart';

class Applicant extends User {
  Applicant({
    required String id,
    required String name,
    required String email,
    required String phone,
    required String password,
    List<String>? savedJobs,
  }) : super(
          id: id,
          name: name,
          email: email,
          phone: phone,
          password: password,
          role: "applicant",
          savedJobs: savedJobs,
        );
}