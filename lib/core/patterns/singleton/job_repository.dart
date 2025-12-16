import '../../../data/model/job.dart';

class JobRepository {
  static final JobRepository _instance = JobRepository._internal();
  JobRepository._internal();

  static JobRepository get instance => _instance;

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
