import '../../core/patterns/builder/job_builder.dart';
import '../../core/patterns/facade/job_management_facade.dart';
import '../../core/patterns/facade/application_management_facade.dart';
import '../../core/patterns/strategy/application_status_strategy.dart';
import '../../data/model/job.dart';
import '../../data/model/job_application.dart';

class CompanyController {
  final JobManagementFacade _jobFacade = JobManagementFacade();
  final ApplicationManagementFacade _applicationFacade =
      ApplicationManagementFacade();

  void postJob({
    required String title,
    required String description,
    required String location,
  }) {
    final job = JobBuilder()
        .setId(DateTime.now().toString())
        .setTitle(title)
        .setDescription(description)
        .setLocation(location)
        .build();

    _jobFacade.postJob(job);
  }

  List<JobApplication> get applications =>
      _applicationFacade.getAllApplications();

  
  void updateApplicationStatus(
    JobApplication application,
    ApplicationStatusStrategy strategy,
  ) {
    _applicationFacade.updateStatus(application, strategy);
  }

  List<Job> get jobs => _jobFacade.getJobs();
}
