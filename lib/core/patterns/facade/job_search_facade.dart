import '../../../data/model/job.dart';
import '../../patterns/strategy/job_search_strategy.dart';

class JobSearchFacade {
  JobSearchStrategy strategy;

  JobSearchFacade(this.strategy);

  List<Job> search(List<Job> jobs, String keyword) {
    return strategy.search(jobs, keyword);
  }
}
