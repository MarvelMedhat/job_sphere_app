import '../../../data/model/job.dart';

class JobRepository {
  // Lazy initialization - instance is null until first access
  static JobRepository? _instance;
  
  // Private constructor
  JobRepository._internal();

  // Lazy initialization getter - creates instance only when first called
  static JobRepository get instance {
    if (_instance == null) {
      _instance = JobRepository._internal();
    }
    return _instance!;
  }

  final List<Job> _jobs = [];

  void addJob(Job job) => _jobs.add(job);

  void removeJob(String id) =>
      _jobs.removeWhere((job) => job.id == id);

  List<Job> get jobs => _jobs;

  void updateJob(Job updatedJob) {
    final index = _jobs.indexWhere((j) => j.id == updatedJob.id);
    if (index != -1) {
      _jobs[index] = updatedJob;
    }
  }

  void delete(String jobId) {
    _jobs.removeWhere((job) => job.id == jobId);
  }

  List<Job> getCompanyJobs() {
  return List.unmodifiable(_jobs);
    }
}
