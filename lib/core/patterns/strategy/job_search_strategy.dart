import '../../../data/model/job.dart';

abstract class JobSearchStrategy {
  List<Job> search(List<Job> jobs, String keyword);
}
