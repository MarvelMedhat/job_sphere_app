import 'package:flutter/material.dart';
import '../../core/patterns/facade/job_management_facade.dart';
import '../../core/patterns/strategy/job_search_context.dart';
import '../../core/patterns/strategy/search_by_location.dart';
import '../../core/patterns/strategy/search_by_title.dart';
import '../../data/model/job.dart';
import 'job_details_screen.dart';

class JobListScreen extends StatefulWidget {
  const JobListScreen({super.key});

  @override
  State<JobListScreen> createState() => _JobListScreenState();
}

class _JobListScreenState extends State<JobListScreen> {

  final JobManagementFacade _jobFacade = JobManagementFacade();

  late JobSearchContext searchContext;

  String searchQuery = '';
  String? selectedLocation;
  int? minSalary;

  @override
  void initState() {
    super.initState();
    searchContext = JobSearchContext(SearchByTitle());
  }

  List<String> get locations {
    final allLocations = _jobFacade
        .getJobs()
        .map((job) => job.location)
        .toSet()
        .toList();
    allLocations.sort();
    return allLocations;
  }

  List<Job> get filteredJobs {
    List<Job> results = searchContext.performSearch(
      _jobFacade.getJobs(),
      searchQuery,
    );

    // Filter by location
    if (selectedLocation != null) {
      results = results
          .where((job) => job.location == selectedLocation)
          .toList();
    }

    // Filter by salary
    if (minSalary != null) {
      results = results
          .where((job) => (int.tryParse(job.salary) ?? 0) >= minSalary!)
          .toList();
    }

    results = results.where((job) => job.status == "open").toList();

    return results;
  }

  @override
  Widget build(BuildContext context) {
    final filtered = filteredJobs;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Job List", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
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
                            onChanged: (value) {
                              setState(() {
                                searchQuery = value;
                                searchContext.setStrategy(SearchByTitle());
                              });
                            },
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
                                  onChanged: (value) {
                                    setState(() {
                                      selectedLocation = value;
                                      if (value != null) {
                                        searchContext.setStrategy(
                                          SearchByLocation(),
                                        );
                                      } else {
                                        searchContext.setStrategy(
                                          SearchByTitle(),
                                        );
                                      }
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Salary filter
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
                                  onChanged: (value) {
                                    setState(() {
                                      minSalary = value;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
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
                                margin: const EdgeInsets.symmetric(vertical: 6),
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ListTile(
                                  title: Text(
                                    job.title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(
                                    "${job.location} • ${job.salary}",
                                  ),
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
