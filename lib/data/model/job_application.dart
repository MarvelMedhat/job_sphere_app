import 'dart:typed_data';

class JobApplication {
  final String id;
  final String applicantId;
  final String jobId;
  final String? resumePath;
  final Uint8List? resumeBytes; // File bytes for web platform
  String status; // Pending | Interview | Rejected
  final DateTime appliedAt;

  JobApplication({
    required this.id,
    required this.applicantId,
    required this.jobId,
    this.resumePath,
    this.resumeBytes,
    this.status = "Pending",
    DateTime? appliedAt,
  }) : appliedAt = appliedAt ?? DateTime.now();
}
