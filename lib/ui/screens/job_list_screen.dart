import 'package:flutter/material.dart';
import '../../core/patterns/singleton/job_repository.dart';
import 'job_details_screen.dart';

class JobListScreen extends StatefulWidget {
  const JobListScreen({super.key});

  @override
  State<JobListScreen> createState() => _JobListScreenState();
}

class _JobListScreenState extends State<JobListScreen> {
  final jobs = JobRepository.instance.jobs;

  String searchQuery = '';
  String? selectedLocation;
  int? minSalary;

  List<String> get locations {
    final allLocations = jobs.map((job) => job.location).toSet().toList();
    allLocations.sort();
    return allLocations;
  }

  List filteredJobs() {
    return jobs.where((job) {
      if (job.status != "open") return false;

      final matchesTitle =
          job.title.toLowerCase().contains(searchQuery.toLowerCase());
      final matchesLocation =
          selectedLocation == null || job.location == selectedLocation;
      final jobSalary = int.tryParse(job.salary) ?? 0;
      final matchesSalary = minSalary == null || jobSalary >= minSalary!;

      return matchesTitle && matchesLocation && matchesSalary;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = filteredJobs();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Job List",
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
                colors: [Colors.purpleAccent, Colors.deepPurple],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  const SizedBox(height: 8),

                  // Filters: Search + Location + Salary
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          TextField(
                            decoration: const InputDecoration(
                              labelText: "Search by job title",
                              prefixIcon: Icon(Icons.search),
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) => setState(() {
                              searchQuery = value;
                            }),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: DropdownButtonFormField<String>(
                                  value: selectedLocation,
                                  hint: const Text("Location"),
                                  items: [null, ...locations].map((loc) {
                                    return DropdownMenuItem(
                                      value: loc,
                                      child: Text(loc ?? "Location"),
                                    );
                                  }).toList(),
                                  onChanged: (value) => setState(() {
                                    selectedLocation = value;
                                  }),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: DropdownButtonFormField<int>(
                                  value: minSalary,
                                  hint: const Text("Salary"),
                                  items: const [
                                    DropdownMenuItem(
                                      value: null,
                                      child: Text("Salary"),
                                    ),
                                    DropdownMenuItem(
                                      value: 3000,
                                      child: Text("8000+"),
                                    ),
                                    DropdownMenuItem(
                                      value: 5000,
                                      child: Text("10000+"),
                                    ),
                                    DropdownMenuItem(
                                      value: 8000,
                                      child: Text("20000+"),
                                    ),
                                  ],
                                  onChanged: (value) => setState(() {
                                    minSalary = value;
                                  }),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Job List
                  Expanded(
                    child: filtered.isEmpty
                        ? const Center(
                            child: Text(
                              "No jobs found",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          )
                        : ListView.builder(
                            itemCount: filtered.length,
                            itemBuilder: (_, index) {
                              final job = filtered[index];
                              return Card(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 6),
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ListTile(
                                  title: Text(
                                    job.title,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                      "${job.location} • ${job.salary}"),
                                  trailing: const Icon(
                                    Icons.arrow_forward_ios,
                                    size: 18,
                                  ),
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          JobDetailsScreen(job: job),
                                    ),
                                  ),
                                ),
                              );
                            },
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
