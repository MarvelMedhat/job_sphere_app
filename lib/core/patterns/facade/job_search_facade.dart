import '../../../data/model/job.dart';
import '../../patterns/strategy/job_search_strategy.dart';
import '../../patterns/strategy/job_search_context.dart';

/// Facade for Job Search
/// Simplifies job searching with different strategies
/// Following the Facade pattern: aggregates JobSearchContext subsystem
class JobSearchFacade {
  // Subsystem: Job Search Context (which manages strategies)
  final JobSearchContext _context;

  JobSearchFacade(this._context);

  /// Perform search using the current strategy
  List<Job> search(List<Job> jobs, String keyword) {
    return _context.performSearch(jobs, keyword);
  }

  /// Change search strategy dynamically
  void setStrategy(JobSearchStrategy strategy) {
    _context.setStrategy(strategy);
  }
}
