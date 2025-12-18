import '../../patterns/strategy/application_status_strategy.dart';
import '../../patterns/strategy/application_status_context.dart';
import '../../patterns/singleton/application_repository.dart';
import '../../../data/model/job_application.dart';

class ApplicationManagementFacade {
  final ApplicationRepository _repository = ApplicationRepository.instance;

  void updateStatus(
    JobApplication application,
    ApplicationStatusStrategy strategy,
  ) {
    final context = ApplicationStatusContext(strategy);
    application.status = context.getStatus();
    _repository.update(application);
  }
  
  List<JobApplication> getAllApplications() {
    return _repository.applications;
  }

  List<JobApplication> getApplicationsForJob(String jobId) {
    return _repository.applications.where((app) => app.jobId == jobId).toList();
  }

  void submitApplication(JobApplication application) {
    _repository.submit(application);
  }
}
