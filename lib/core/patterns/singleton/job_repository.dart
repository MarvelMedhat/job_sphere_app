import '../../../data/model/job.dart';
import '../../patterns/singleton/UserRepository.dart';
import '../../patterns/singleton/application_repository.dart';

class JobRepository {
  static JobRepository? _instance;

  JobRepository._internal();

  static JobRepository get instance {
    _instance ??= JobRepository._internal();
    return _instance!;
  }

  final List<Job> _jobs = [];

  List<Job> get jobs => List.unmodifiable(_jobs);

  void addJob(Job job) {
    _jobs.add(job);
  }

  void removeJob(String jobId) {
    _jobs.removeWhere((job) => job.id == jobId);
    UserRepository.instance.removeJobFromAllUsers(jobId);
    ApplicationRepository.instance.removeApplicationsByJobId(jobId);
  }

  void updateJob(Job updatedJob) {
    final index = _jobs.indexWhere((j) => j.id == updatedJob.id);
    if (index != -1) {
      _jobs[index] = updatedJob;

      if (updatedJob.status != "open") {
        UserRepository.instance.removeJobFromAllUsers(updatedJob.id);
      }
    }
  }

  List<Job> getCompanyJobs() {
    return List.unmodifiable(_jobs);
  }
}
