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

  bool _isEditing = false;
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  final Color primaryColor = Colors.deepPurple;
  final Color accentColor = Colors.purpleAccent;
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
        title: const Text(
          "Profile",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Gradient Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepPurple, Colors.purpleAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // Decorative Circles
          Positioned(
            top: -50,
            left: -50,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -80,
            right: -60,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // Main Content
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
                    child: ListTile(
                      title: _isEditing
                          ? TextField(
                              controller: _nameController,
                              decoration:
                                  const InputDecoration(labelText: "Name"),
                            )
                          : Text(
                              user.name,
                              style: const TextStyle(fontSize: 20),
                            ),
                      subtitle: _isEditing
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextField(
                                  controller: _emailController,
                                  decoration: const InputDecoration(
                                      labelText: "Email"),
                                ),
                                TextField(
                                  controller: _phoneController,
                                  decoration: const InputDecoration(
                                      labelText: "Phone"),
                                ),
                              ],
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Email: ${user.email}"),
                                Text("Phone: ${user.phone}"),
                              ],
                            ),
                      trailing: IconButton(
                        icon: Icon(
                          _isEditing ? Icons.save : Icons.edit,
                          color: primaryColor,
                        ),
                        onPressed: () {
                          _isEditing ? _saveProfile() : setState(() => _isEditing = true);
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Saved Jobs Header
                  const Text(
                    "Saved Jobs",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Saved Jobs List
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
                                    content: Text("Job removed from saved"),
                                  ),
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
