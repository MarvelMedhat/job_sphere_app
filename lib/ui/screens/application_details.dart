import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import '/core/patterns/strategy/application_status_context.dart';
import 'dart:html' as html;
import '../../data/model/job_application.dart';
import '../../data/model/user.dart';
import '../../core/patterns/singleton/application_repository.dart';
import '../../core/patterns/singleton/UserRepository.dart';
import '../../core/patterns/strategy/application_status_strategy.dart';
import 'package:url_launcher/url_launcher.dart';

class ApplicationDetailsScreen extends StatefulWidget {
  final JobApplication application;

  const ApplicationDetailsScreen({super.key, required this.application});

  @override
  State<ApplicationDetailsScreen> createState() =>
      _ApplicationDetailsScreenState();
}

class _ApplicationDetailsScreenState extends State<ApplicationDetailsScreen> {
  late ApplicationStatusContext statusContext;
  User? applicant;

  final Color cardColor = Colors.white.withOpacity(0.95);

  @override
  void initState() {
    super.initState();

    applicant = UserRepository.instance.getUserById(
      widget.application.applicantId,
    );

    //check status and set strategy
    statusContext = ApplicationStatusContext(
      widget.application.status == "Accepted"
          ? AcceptedStatus()
          : widget.application.status == "Rejected"
          ? RejectedStatus()
          : PendingStatus(),
    );
  }

  void openResume(String? fileName, Uint8List? bytes) async {
    if (fileName == null || fileName.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("No resume uploaded")));
      return;
    }
    
    // Web
    if (kIsWeb) {
      if (bytes == null || bytes.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Resume file data not available")),
        );
        return;
      }

      try {
        final blob = html.Blob([bytes], 'application/pdf');
        final url = html.Url.createObjectUrlFromBlob(blob);
        html.window.open(url, '_blank');
        Future.delayed(const Duration(seconds: 1), () {
          html.Url.revokeObjectUrl(url);
        });
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error opening resume: $e")));
      }
      // Mobile/Desktop
    } else {
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
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepPurple, Colors.purpleAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
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
                            "Name: ${applicant?.name}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text("Email: ${applicant?.email}"),
                          const SizedBox(height: 6),
                          Text("Phone: ${applicant?.phone}"),
                          const SizedBox(height: 6),
                          Text(
                            "Applied on: ${app.appliedAt.toLocal().toString().split(' ')[0]}",
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
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
                            value: statusContext.getStatus(),
                            items: const [
                              DropdownMenuItem(
                                value: "Pending",
                                child: Text("Pending"),
                              ),
                              DropdownMenuItem(
                                value: "Accepted",
                                child: Text("Accepted"),
                              ),
                              DropdownMenuItem(
                                value: "Rejected",
                                child: Text("Rejected"),
                              ),
                            ],
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  // Set strategy 
                                  if (value == "Pending") {
                                    statusContext.setStrategy(PendingStatus());
                                  } else if (value == "Accepted") {
                                    statusContext.setStrategy(AcceptedStatus());
                                  } else if (value == "Rejected") {
                                    statusContext.setStrategy(RejectedStatus());
                                  }

                                  // Save to application model and repository
                                  widget.application.status = statusContext
                                      .getStatus();
                                  ApplicationRepository.instance.update(
                                    widget.application,
                                  );
                                });
                              }
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
