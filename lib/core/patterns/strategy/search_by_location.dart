import 'job_search_strategy.dart';
import '../../../data/model/job.dart';

class SearchByLocation implements JobSearchStrategy {
  @override
  List<Job> search(List<Job> jobs, String keyword) {
    return jobs
        .where((job) =>
            job.location.toLowerCase().contains(keyword.toLowerCase()))
        .toList();
  }
}
