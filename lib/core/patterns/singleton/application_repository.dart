import '../../../data/model/job_application.dart';

class ApplicationRepository {
  static final ApplicationRepository _instance =
      ApplicationRepository._internal();

  ApplicationRepository._internal();
  static ApplicationRepository get instance => _instance;

  final List<JobApplication> applications = [];

  void submit(JobApplication application) {
    applications.add(application);
  }

  void update(JobApplication app) {
    final index = applications.indexWhere((a) => a.id == app.id);
    if (index != -1) {
      applications[index] = app;
    }
  }

  List<JobApplication> byJob(String jobId) {
    return applications.where((a) => a.jobId == jobId).toList();
  }
}
