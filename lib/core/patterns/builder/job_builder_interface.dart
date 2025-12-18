import '../../../data/model/job.dart';


abstract class JobBuilderInterface {
  void buildId(String id);
  
  void buildTitle(String title);
  
  void buildDescription(String description);
  
  void buildLocation(String location);
  
  void buildSalary(String salary);
  
  void buildRequirements(String requirements);
  
  void buildStatus(String status);
  
  Job getResult();
}
