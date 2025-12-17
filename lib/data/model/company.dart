import 'user.dart';

class Company extends User {
  String companyName;

  Company({
    required String id,
    required String name,
    required String email,
    required String phone,
    required String password,
    required this.companyName,
  }) : super(
          id: id,
          name: name,
          email: email,
          phone: phone,
          password: password,
          role: "company",
        );
}