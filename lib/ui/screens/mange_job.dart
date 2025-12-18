import 'package:flutter/material.dart';
import '/ui/screens/post_job_screen.dart';
import '../../data/model/job.dart';
import '../../core/patterns/singleton/job_repository.dart';

class CompanyJobsScreen extends StatefulWidget {
  const CompanyJobsScreen({super.key});

  @override
  State<CompanyJobsScreen> createState() => _CompanyJobsScreenState();
}

class _CompanyJobsScreenState extends State<CompanyJobsScreen> {
  late List<Job> _jobs;

  @override
  void initState() {
    super.initState();
    _jobs = JobRepository.instance.getCompanyJobs();
  }

  void _pauseOrResume(Job job) {
    final updatedJob = Job(
      id: job.id,
      title: job.title,
      description: job.description,
      location: job.location,
      salary: job.salary,
      requirements: job.requirements,
      status: job.status == "open" ? "paused" : "open",
    );

    JobRepository.instance.updateJob(updatedJob);
    setState(() {
      _jobs = JobRepository.instance.getCompanyJobs();
    });
  }

  void _deleteJob(Job job) {
  JobRepository.instance.removeJob(job.id);
  setState(() {
    _jobs = JobRepository.instance.getCompanyJobs();
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "My Posted Jobs",
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
            child: _jobs.isEmpty
                ? const Center(
                    child: Text(
                      "No jobs posted yet",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: _jobs.length,
                    itemBuilder: (context, index) {
                      final job = _jobs[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          title: Text(
                            job.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          subtitle: Text(
                            "Status: ${job.status}\nLocation: ${job.location} • Salary: ${job.salary}",
                          ),
                          isThreeLine: true,
                          trailing: PopupMenuButton<String>(
                            onSelected: (value) {
                              if (value == "edit") {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => PostJobScreen(job: job),
                                  ),
                                ).then((_) {
                                  setState(() {
                                    _jobs = JobRepository.instance.getCompanyJobs();
                                  });
                                });
                              } else if (value == "pause") {
                                _pauseOrResume(job);
                              } else if (value == "delete") {
                                _deleteJob(job);
                              }
                            },
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: "edit",
                                child: Text("Edit"),
                              ),
                              PopupMenuItem(
                                value: "pause",
                                child: Text(
                                  job.status == "open"
                                      ? "Pause Job"
                                      : "Resume Job",
                                ),
                              ),
                              const PopupMenuItem(
                                value: "delete",
                                child: Text(
                                  "Delete",
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
