import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/model/job.dart';
import 'package:flutter_application_1/ui/screens/application_details.dart';
import '../../core/patterns/singleton/application_repository.dart';
import '../../core/patterns/singleton/job_repository.dart';

class ApplicationsScreen extends StatefulWidget {
  const ApplicationsScreen({super.key});

  @override
  State<ApplicationsScreen> createState() => _ApplicationsScreenState();
}

class _ApplicationsScreenState extends State<ApplicationsScreen> {
  String searchQuery = '';

  final Color primaryColor = Colors.deepPurple;
  final Color accentColor = Colors.purpleAccent;
  final Color cardColor = Colors.white.withOpacity(0.95);

  @override
  Widget build(BuildContext context) {
    final applications = ApplicationRepository.instance.applications;
    final jobs = JobRepository.instance.jobs;

    String jobTitle(String? jobId) {
      final job = jobs.cast<Job?>().firstWhere(
        (j) => j!.id == jobId,
        orElse: () => null,
      );
      return job?.title ?? "Unknown";
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

          // Decorative circles
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

          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 8),

                // Search bar
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

                // Applications list
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
                                subtitle: Text("Status: ${app.status}"),
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
