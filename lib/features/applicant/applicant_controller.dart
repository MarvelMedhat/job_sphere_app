import '../../core/patterns/facade/job_search_facade.dart';
import '../../core/patterns/facade/job_management_facade.dart';
import '../../core/patterns/facade/application_management_facade.dart';
import '../../core/patterns/strategy/job_search_strategy.dart';
import '../../core/patterns/strategy/job_search_context.dart';
import '../../core/patterns/builder/job_application_builder.dart';
import '../../data/model/job.dart';

class ApplicantController {
  final JobManagementFacade _jobFacade = JobManagementFacade();
  final ApplicationManagementFacade _applicationFacade =
      ApplicationManagementFacade();

  List<Job> searchJobs({
    required JobSearchStrategy strategy,
    required String keyword,
  }) {
    final jobs = _jobFacade.getJobs();
    final context = JobSearchContext(strategy);
    final searchFacade = JobSearchFacade(context);
    return searchFacade.search(jobs, keyword);
  }

  void applyForJob({
    required String applicantId,
    required String jobId,
    required String resumePath,
  }) {
    final application = JobApplicationBuilder()
        .setApplicant(applicantId)
        .setJob(jobId)
        .attachResume(resumePath)
        .build();

    _applicationFacade.submitApplication(application);
  }
}
