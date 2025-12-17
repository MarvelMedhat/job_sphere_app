import '../../patterns/strategy/application_status_strategy.dart';
import '../../patterns/strategy/application_status_context.dart';
import '../../patterns/singleton/application_repository.dart';
import '../../../data/model/job_application.dart';

/// Facade for Application Management
/// Simplifies complex subsystem interactions for managing job applications
/// Following the Facade pattern: aggregates subsystems and provides simple interface
class ApplicationManagementFacade {
  // Subsystem: Application Repository
  final ApplicationRepository _repository = ApplicationRepository.instance;

  /// Update application status using strategy pattern
  /// Delegates to ApplicationStatusContext which handles strategy
  void updateStatus(
    JobApplication application,
    ApplicationStatusStrategy strategy,
  ) {
    final context = ApplicationStatusContext(strategy);
    application.status = context.getStatus();
    _repository.update(application);
  }

  /// Get all applications
  List<JobApplication> getAllApplications() {
    return _repository.applications;
  }

  /// Get applications for a specific job
  List<JobApplication> getApplicationsForJob(String jobId) {
    return _repository.applications.where((app) => app.jobId == jobId).toList();
  }

  /// Submit a new application
  void submitApplication(JobApplication application) {
    _repository.submit(application);
  }
}
