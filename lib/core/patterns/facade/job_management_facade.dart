import '../../patterns/singleton/job_repository.dart';
import '../../../data/model/job.dart';

class JobManagementFacade {
  final JobRepository _repo = JobRepository.instance;

  void postJob(Job job) {
    _repo.addJob(job);
  }

  void removeJob(String id) {
    _repo.removeJob(id);
  }

  List<Job> getJobs() => _repo.jobs;
}
