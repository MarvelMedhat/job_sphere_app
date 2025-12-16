import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../../core/patterns/builder/job_application_builder.dart';
import '../../core/patterns/singleton/application_repository.dart';
import '../../core/patterns/facade/auth_facade.dart';
import '../../data/model/job.dart';

class JobDetailsScreen extends StatefulWidget {
  final Job job;
  const JobDetailsScreen({super.key, required this.job});

  @override
  State<JobDetailsScreen> createState() => _JobDetailsScreenState();
}

class _JobDetailsScreenState extends State<JobDetailsScreen> {
  final AuthFacade _authFacade = AuthFacade();
  PlatformFile? _selectedFile;
  Uint8List? _resumeBytes;

  Future<void> _pickResume() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
        withData: kIsWeb,
      );

      if (result == null) return;

      setState(() {
        _selectedFile = result.files.first;
        if (kIsWeb) _resumeBytes = result.files.first.bytes;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Selected: ${_selectedFile!.name}")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error picking file: $e")),
      );
    }
  }

  void _apply() {
    if (_selectedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please upload your resume first")),
      );
      return;
    }

    final resumeIdentifier =
        kIsWeb ? _selectedFile!.name : _selectedFile!.path!;

    final application = JobApplicationBuilder()
        .setId(DateTime.now().millisecondsSinceEpoch.toString())
        .setApplicant(_authFacade.getCurrentUser()!.id)
        .setJob(widget.job.id)
        .attachResume(resumeIdentifier)
        .build();

    ApplicationRepository.instance.submit(application);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Applied successfully!")),
    );
  }

  void _saveJob() {
    final user = _authFacade.getCurrentUser()!;
    if (!user.savedJobs.contains(widget.job.id)) {
      user.savedJobs.add(widget.job.id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Job saved")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Job already saved")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final job = widget.job;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Job Details",
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
              padding: const EdgeInsets.all(16),
              child: ListView(
                children: [
                  Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            job.title,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text("Location: ${job.location}",
                              style: const TextStyle(fontSize: 16)),
                          Text("Status: ${job.status}",
                              style: const TextStyle(fontSize: 16)),
                          Text("Salary: ${job.salary}",
                              style: const TextStyle(fontSize: 16)),
                          const SizedBox(height: 12),
                          const Text(
                            "Requirements:",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(job.requirements,
                              style: const TextStyle(fontSize: 16)),
                          const SizedBox(height: 12),
                          const Text(
                            "Description:",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(job.description,
                              style: const TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Resume Upload
                  ElevatedButton.icon(
                    onPressed: _pickResume,
                    icon: const Icon(Icons.upload_file),
                    label: Text(
                      _selectedFile == null
                          ? "Upload Resume"
                          : "Selected: ${_selectedFile!.name}",
                    ),
                    style: ElevatedButton.styleFrom(
                      textStyle: const TextStyle(color: Colors.white),
                      backgroundColor: Colors.deepPurpleAccent,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Apply Button
                  ElevatedButton.icon(
                    onPressed: _apply,
                    icon: const Icon(Icons.send),
                    label: const Text("Apply"),
                    style: ElevatedButton.styleFrom(
                      textStyle: const TextStyle(color: Colors.white),
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Save Job Button
                  ElevatedButton.icon(
                    onPressed: _saveJob,
                    icon: const Icon(Icons.bookmark_add),
                    label: const Text("Save Job"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.greenAccent,
                      padding: const EdgeInsets.symmetric(vertical: 14),
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
