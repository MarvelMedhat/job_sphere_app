class User {
  final String id;
  String name;
  String email;
  String phone;
  final String role; // "applicant" or "company"
  List<String> savedJobs; 

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    List<String>? savedJobs,
  }) : savedJobs = savedJobs ?? [];
}


