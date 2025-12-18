import 'dart:typed_data';
import '../../../data/model/job_application.dart';
import 'job_application_builder_interface.dart';

class JobApplicationBuilder implements JobApplicationBuilderInterface {
  String? _id;
  String? _applicantId;
  String? _jobId;
  String? _resumePath;
  Uint8List? _resumeBytes;
  String _status = "Pending";

  @override
  void buildId(String id) {
    _id = id;
  }

  @override
  void buildApplicant(String applicantId) {
    _applicantId = applicantId;
  }

  @override
  void buildJob(String jobId) {
    _jobId = jobId;
  }

  @override
  void buildResumePath(String? path) {
    _resumePath = path;
  }

  @override
  void buildResumeBytes(Uint8List? bytes) {
    _resumeBytes = bytes;
  }

  @override
  void buildStatus(String status) {
    _status = status;
  }

  @override
  JobApplication getResult() {
    if (_id == null || _applicantId == null || _jobId == null) {
      throw Exception("Missing required JobApplication fields");
    }

    return JobApplication(
      id: _id!,
      applicantId: _applicantId!,
      jobId: _jobId!,
      resumePath: _resumePath,
      resumeBytes: _resumeBytes,
      status: _status,
    );
  }

  JobApplicationBuilder setId(String id) {
    buildId(id);
    return this;
  }

  JobApplicationBuilder setApplicant(String applicantId) {
    buildApplicant(applicantId);
    return this;
  }

  JobApplicationBuilder setJob(String jobId) {
    buildJob(jobId);
    return this;
  }

  JobApplicationBuilder attachResume(String path) {
    buildResumePath(path);
    return this;
  }

  JobApplicationBuilder attachResumeBytes(Uint8List bytes) {
    buildResumeBytes(bytes);
    return this;
  }

  JobApplicationBuilder setStatus(String status) {
    buildStatus(status);
    return this;
  }

  JobApplication build() {
    return getResult();
  }
}
