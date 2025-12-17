import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'dart:html' as html;
import '../../data/model/job_application.dart';
import '../../data/model/user.dart';
import '../../core/patterns/singleton/application_repository.dart';
import '../../core/patterns/singleton/UserRepository.dart';
import 'package:url_launcher/url_launcher.dart';

class ApplicationDetailsScreen extends StatefulWidget {
  final JobApplication application;

  const ApplicationDetailsScreen({super.key, required this.application});

  @override
  State<ApplicationDetailsScreen> createState() =>
      _ApplicationDetailsScreenState();
}

class _ApplicationDetailsScreenState extends State<ApplicationDetailsScreen> {
  late String status;
  User? applicant;

  final Color primaryColor = Colors.deepPurple;
  final Color accentColor = Colors.purpleAccent;
  final Color cardColor = Colors.white.withOpacity(0.95);

  @override
  void initState() {
    super.initState();
    status = widget.application.status;

    applicant = UserRepository.instance.getUserById(
      widget.application.applicantId,
    );
  }

  void updateStatus(String newStatus) {
    setState(() {
      status = newStatus;
      widget.application.status = newStatus;
    });
    ApplicationRepository.instance.update(widget.application);
  }

  void openResume(String? fileName, Uint8List? bytes) async {
    if (fileName == null || fileName.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("No resume uploaded")));
      return;
    }

    if (kIsWeb) {
      // Web platform: Create blob and download
      if (bytes == null || bytes.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Resume file data not available")),
        );
        return;
      }

      try {
        // Create a blob from the bytes
        final blob = html.Blob([bytes], 'application/pdf');
        final url = html.Url.createObjectUrlFromBlob(blob);

        // Open in new tab
        html.window.open(url, '_blank');

        // Clean up the URL after a delay
        Future.delayed(const Duration(seconds: 1), () {
          html.Url.revokeObjectUrl(url);
        });
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error opening resume: $e")));
      }
    } else {
      // Mobile platform: Use url_launcher
      final Uri url = Uri.parse(fileName);
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Cannot open resume")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final app = widget.application;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Application Details",
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
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ListView(
                children: [
                  // Applicant Info Card
                  Card(
                    color: cardColor,
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Name: ${applicant?.name ?? 'Unknown'}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text("Email: ${applicant?.email ?? 'Unknown'}"),
                          const SizedBox(height: 6),
                          Text("Phone: ${applicant?.phone ?? 'Unknown'}"),
                          const SizedBox(height: 6),
                          Text(
                            "Applied on: ${app.appliedAt.toLocal().toString().split(' ')[0]}",
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Resume Card
                  Card(
                    color: cardColor,
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListTile(
                      leading: const Icon(
                        Icons.picture_as_pdf,
                        color: Colors.red,
                      ),
                      title: const Text("View Resume"),
                      subtitle: Text(app.resumePath ?? "No resume uploaded"),
                      onTap: () => openResume(app.resumePath, app.resumeBytes),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Status Dropdown
                  Card(
                    color: cardColor,
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Application Status",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          DropdownButton<String>(
                            isExpanded: true,
                            value: status,
                            items: const [
                              DropdownMenuItem(
                                value: "Pending",
                                child: Text("Pending"),
                              ),
                              DropdownMenuItem(
                                value: "Interview",
                                child: Text("Interview"),
                              ),
                              DropdownMenuItem(
                                value: "Rejected",
                                child: Text("Rejected"),
                              ),
                            ],
                            onChanged: (value) {
                              if (value != null) updateStatus(value);
                            },
                          ),
                        ],
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
