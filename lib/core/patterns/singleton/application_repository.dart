import '../../../data/model/job_application.dart';

class ApplicationRepository {
  static ApplicationRepository? _instance;

  ApplicationRepository._internal();
  
  static ApplicationRepository get instance {
    if (_instance == null) {
      _instance = ApplicationRepository._internal();
    }
    return _instance!;
  }

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

  void removeApplicationsByJobId(String jobId) {
    applications.removeWhere((app) => app.jobId == jobId);
  }

  List<JobApplication> byJob(String jobId) {
    return applications.where((a) => a.jobId == jobId).toList();
  }
}
