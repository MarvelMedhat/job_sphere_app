import 'job_search_strategy.dart';
import '../../../data/model/job.dart';

class JobSearchContext {
  JobSearchStrategy _strategy;

  JobSearchContext(this._strategy);

  void setStrategy(JobSearchStrategy strategy) {
    _strategy = strategy;
  }

  List<Job> performSearch(List<Job> jobs, String keyword) {
    return _strategy.search(jobs, keyword);
  }
}
