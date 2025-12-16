import 'external_resume_api.dart';

class ResumeAdapter {
  final ExternalResumeAPI api;

  ResumeAdapter(this.api);

  String getResume(String applicantId) {
    return api.downloadResume(applicantId);
  }
}
