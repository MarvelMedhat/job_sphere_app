import 'job_builder_interface.dart';
import '../../../data/model/job.dart';

class JobDirector {
  final JobBuilderInterface _builder;

  JobDirector(this._builder);

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
