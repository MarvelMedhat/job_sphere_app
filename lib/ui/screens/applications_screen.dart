import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/model/job.dart';
import 'package:flutter_application_1/ui/screens/application_details.dart';
import '../../core/patterns/singleton/application_repository.dart';
import '../../core/patterns/singleton/job_repository.dart';
import '../../core/patterns/singleton/UserRepository.dart';
import '../../data/model/user.dart';

class ApplicationsScreen extends StatefulWidget {
  const ApplicationsScreen({super.key});

  @override
  State<ApplicationsScreen> createState() => _ApplicationsScreenState();
}

class _ApplicationsScreenState extends State<ApplicationsScreen> {
  String searchQuery = '';

  final Color cardColor = Colors.white.withOpacity(0.95);

  @override
  Widget build(BuildContext context) {
    final applications = ApplicationRepository.instance.applications;
    final jobs = JobRepository.instance.jobs;

    // 🔹 Get job title by jobId
    String jobTitle(String? jobId) {
      final job = jobs.cast<Job?>().firstWhere(
        (j) => j!.id == jobId,
        orElse: () => null,
      );
      return job?.title ?? "Unknown Job";
    }

    // 🔹 Get applicant name by applicantId
    String applicantName(String? applicantId) {
      final user = UserRepository.instance.getUserById(applicantId);
      return user?.name ?? "Unknown Applicant";
    }

    final filtered = applications.where((app) {
      return jobTitle(app.jobId)
          .toLowerCase()
          .contains(searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Job Applications",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
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
            child: Column(
              children: [
                const SizedBox(height: 8),

                // 🔍 Search bar
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: "Search by job title",
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.9),
                    ),
                    onChanged: (value) {
                      setState(() => searchQuery = value);
                    },
                  ),
                ),

                // 📄 Applications list
                Expanded(
                  child: filtered.isEmpty
                      ? const Center(
                          child: Text(
                            "No applications found",
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      : ListView.builder(
                          itemCount: filtered.length,
                          itemBuilder: (_, index) {
                            final app = filtered[index];
                            return Card(
                              color: cardColor,
                              elevation: 6,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: ListTile(
                                title: Text(jobTitle(app.jobId)),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Applicant: ${applicantName(app.applicantId)}",
                                    ),
                                    Text("Status: ${app.status}"),
                                  ],
                                ),
                                trailing:
                                    const Icon(Icons.arrow_forward_ios),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          ApplicationDetailsScreen(
                                        application: app,
                                      ),
                                    ),
                                  ).then((_) => setState(() {}));
                                },
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
