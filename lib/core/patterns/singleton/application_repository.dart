import '../../../data/model/job_application.dart';

class ApplicationRepository {
  // Lazy initialization - instance is null until first access
  static ApplicationRepository? _instance;

  // Private constructor
  ApplicationRepository._internal();
  
  // Lazy initialization getter - creates instance only when first called
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

  List<JobApplication> byJob(String jobId) {
    return applications.where((a) => a.jobId == jobId).toList();
  }
}
