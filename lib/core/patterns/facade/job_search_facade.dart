import '../../../data/model/job.dart';
import '../../patterns/strategy/job_search_strategy.dart';
import '../../patterns/strategy/job_search_context.dart';

class JobSearchFacade {
  
  final JobSearchContext _context;

  JobSearchFacade(this._context);

  List<Job> search(List<Job> jobs, String keyword) {
    return _context.performSearch(jobs, keyword);
  }


  void setStrategy(JobSearchStrategy strategy) {
    _context.setStrategy(strategy);
  }
}
