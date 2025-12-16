import '../../core/patterns/facade/job_search_facade.dart';
import '../../core/patterns/strategy/job_search_strategy.dart';
import '../../core/patterns/builder/job_application_builder.dart';
import '../../core/patterns/singleton/application_repository.dart';
import '../../core/patterns/singleton/job_repository.dart';
import '../../data/model/job.dart';

class ApplicantController {
  /// 🔍 Search jobs using Strategy
  List<Job> searchJobs({
    required JobSearchStrategy strategy,
    required String keyword,
  }) {
    final jobs = JobRepository.instance.jobs;
    final searchFacade = JobSearchFacade(strategy);
    return searchFacade.search(jobs, keyword);
  }

  /// 📄 Apply for a job using Builder
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

    ApplicationRepository.instance.submit(application);
  }
}
