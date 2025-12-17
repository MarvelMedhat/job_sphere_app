import '../../patterns/singleton/job_repository.dart';
import '../../../data/model/job.dart';

/// Facade for Job Management
/// Simplifies job posting and management operations
/// Following the Facade pattern: aggregates JobRepository subsystem
class JobManagementFacade {
  // Subsystem: Job Repository
  final JobRepository _repo = JobRepository.instance;

  /// Post a new job
  void postJob(Job job) {
    _repo.addJob(job);
  }

  /// Remove a job by ID
  void removeJob(String id) {
    _repo.removeJob(id);
  }

  /// Get all jobs
  List<Job> getJobs() => _repo.jobs;

  /// Get job by ID
  Job? getJobById(String id) {
    try {
      return _repo.jobs.firstWhere((job) => job.id == id);
    } catch (e) {
      return null;
    }
  }
}
