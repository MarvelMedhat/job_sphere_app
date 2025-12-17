import '../../../data/model/job.dart';

/// Abstract Builder interface for Job construction
/// Defines all the building steps required to construct a Job object
abstract class JobBuilderInterface {
  void buildId(String id);
  
  void buildTitle(String title);
  
  void buildDescription(String description);
  
  void buildLocation(String location);
  
  void buildSalary(String salary);
  
  void buildRequirements(String requirements);
  
  void buildStatus(String status);
  
  /// Returns the constructed Job object
  Job getResult();
}
