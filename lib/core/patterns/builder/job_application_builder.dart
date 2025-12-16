import '../../../data/model/job_application.dart';

class JobApplicationBuilder {
  String? _id;
  String? _applicantId;
  String? _jobId;
  String? _resumePath;
  String _status = "Pending";

  JobApplicationBuilder setId(String id) {
    _id = id;
    return this;
  }

  JobApplicationBuilder setApplicant(String applicantId) {
    _applicantId = applicantId;
    return this;
  }

  JobApplicationBuilder setJob(String jobId) {
    _jobId = jobId;
    return this;
  }

  JobApplicationBuilder attachResume(String path) {
    _resumePath = path;
    return this;
  }

  JobApplicationBuilder setStatus(String status) {
    _status = status;
    return this;
  }

  JobApplication build() {
    if (_id == null || _applicantId == null || _jobId == null) {
      throw Exception("Missing required JobApplication fields");
    }

    return JobApplication(
      id: _id!,
      applicantId: _applicantId!,
      jobId: _jobId!,
      resumePath: _resumePath,
      status: _status,
    );
  }
}
