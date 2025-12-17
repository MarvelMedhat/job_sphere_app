import 'job_builder_interface.dart';
import '../../../data/model/job.dart';

/// Director class for Job construction
/// Orchestrates the construction process using a JobBuilderInterface
/// Provides different standardized construction workflows
class JobDirector {
  final JobBuilderInterface _builder;

  JobDirector(this._builder);

  /// Constructs a basic job with minimal required fields
  Job constructBasicJob({
    required String id,
    required String title,
    required String description,
    required String location,
    String status = "Active",
  }) {
    _builder.buildId(id);
    _builder.buildTitle(title);
    _builder.buildDescription(description);
    _builder.buildLocation(location);
    _builder.buildStatus(status);
    _builder.buildSalary('');
    _builder.buildRequirements('');
    
    return _builder.getResult();
  }

  /// Constructs a complete job with all fields
  Job constructFullJob({
    required String id,
    required String title,
    required String description,
    required String location,
    required String salary,
    required String requirements,
    String status = "Active",
  }) {
    _builder.buildId(id);
    _builder.buildTitle(title);
    _builder.buildDescription(description);
    _builder.buildLocation(location);
    _builder.buildSalary(salary);
    _builder.buildRequirements(requirements);
    _builder.buildStatus(status);
    
    return _builder.getResult();
  }

  /// Constructs a job with salary information
  Job constructJobWithSalary({
    required String id,
    required String title,
    required String description,
    required String location,
    required String salary,
    String status = "Active",
  }) {
    _builder.buildId(id);
    _builder.buildTitle(title);
    _builder.buildDescription(description);
    _builder.buildLocation(location);
    _builder.buildSalary(salary);
    _builder.buildRequirements('');
    _builder.buildStatus(status);
    
    return _builder.getResult();
  }

  /// Constructs a job with requirements information
  Job constructJobWithRequirements({
    required String id,
    required String title,
    required String description,
    required String location,
    required String requirements,
    String status = "Active",
  }) {
    _builder.buildId(id);
    _builder.buildTitle(title);
    _builder.buildDescription(description);
    _builder.buildLocation(location);
    _builder.buildSalary('');
    _builder.buildRequirements(requirements);
    _builder.buildStatus(status);
    
    return _builder.getResult();
  }
}
