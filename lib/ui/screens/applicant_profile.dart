import 'package:flutter/material.dart';
import '../../core/patterns/facade/auth_facade.dart';
import '../../core/patterns/singleton/job_repository.dart';
import '../../data/model/job.dart';
import 'job_details_screen.dart';

class ApplicantProfileScreen extends StatefulWidget {
  const ApplicantProfileScreen({super.key});

  @override
  State<ApplicantProfileScreen> createState() => _ApplicantProfileScreenState();
}

class _ApplicantProfileScreenState extends State<ApplicantProfileScreen> {
  final AuthFacade _authFacade = AuthFacade();
  final _formKey = GlobalKey<FormState>();

  bool _isEditing = false;
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  final Color primaryColor = Colors.deepPurple;
  final Color cardColor = Colors.white.withOpacity(0.95);

  @override
  void initState() {
    super.initState();
    final user = _authFacade.getCurrentUser()!;
    _nameController = TextEditingController(text: user.name);
    _emailController = TextEditingController(text: user.email);
    _phoneController = TextEditingController(text: user.phone);
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      _authFacade.updateProfile(
        name: _nameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
      );

      setState(() => _isEditing = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile updated!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = _authFacade.getCurrentUser()!;
    final jobs = JobRepository.instance.jobs;

    final savedJobs = user.savedJobs
        .map(
          (jobId) => jobs.firstWhere(
            (job) => job.id == jobId,
            orElse: () => Job(
              id: jobId,
              title: "Unknown Job",
              location: "",
              description: "",
              status: "N/A",
              salary: "",
              requirements: "",
            ),
          ),
        )
        .toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Profile", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepPurple, Colors.purpleAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ListView(
                children: [
                  // Profile Card
                  Card(
                    color: cardColor,
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _isEditing
                                ? TextFormField(
                                    controller: _nameController,
                                    decoration: const InputDecoration(
                                      labelText: "Name",
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Enter name";
                                      }
                                      return null;
                                    },
                                  )
                                : Text(
                                    user.name,
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                            const SizedBox(height: 12),
                            _isEditing
                                ? TextFormField(
                                    controller: _emailController,
                                    decoration: const InputDecoration(
                                      labelText: "Email",
                                    ),
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Enter email";
                                      }
                                      // Validate email ending with .com
                                      if (!RegExp(r'^[\w-.]+@([\w-]+\.)+com$')
                                          .hasMatch(value)) {
                                        return "Enter valid .com email";
                                      }
                                      return null;
                                    },
                                  )
                                : Text("Email: ${user.email}"),
                            const SizedBox(height: 12),
                            _isEditing
                                ? TextFormField(
                                    controller: _phoneController,
                                    decoration: const InputDecoration(
                                      labelText: "Phone",
                                    ),
                                    keyboardType: TextInputType.phone,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Enter phone";
                                      }
                                      // Validate exactly 11 digits
                                      if (!RegExp(r'^\d{11}$').hasMatch(value)) {
                                        return "Phone must be 11 digits";
                                      }
                                      return null;
                                    },
                                  )
                                : Text("Phone: ${user.phone}"),
                            const SizedBox(height: 12),
                            Align(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton(
                                onPressed: _isEditing ? _saveProfile : () {
                                  setState(() => _isEditing = true);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryColor,
                                ),
                                child: Text(
                                  _isEditing ? "Save" : "Edit",
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Saved Jobs
                  const Text(
                    "Saved Jobs",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 12),
                  ...savedJobs.map(
                    (job) => Card(
                      color: cardColor,
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: ListTile(
                        title: Text(job.title),
                        subtitle: Text(job.location),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  user.savedJobs.remove(job.id);
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("Job removed from saved")),
                                );
                              },
                            ),
                            const Icon(Icons.arrow_forward_ios, size: 18),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => JobDetailsScreen(job: job),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
