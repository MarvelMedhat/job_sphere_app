import '../../../data/model/job.dart';
import 'job_builder_interface.dart';

/// Concrete Builder implementation for Job construction
/// Implements the JobBuilderInterface to build Job objects step by step
class JobBuilder implements JobBuilderInterface {
  String? _id;
  String? _title;
  String? _description;
  String? _location;
  String? _salary;
  String? _requirements;
  String _status = "Active";

  @override
  void buildId(String id) {
    _id = id;
  }

  @override
  void buildTitle(String title) {
    _title = title;
  }

  @override
  void buildDescription(String description) {
    _description = description;
  }

  @override
  void buildLocation(String location) {
    _location = location;
  }

  @override
  void buildSalary(String salary) {
    _salary = salary;
  }

  @override
  void buildRequirements(String requirements) {
    _requirements = requirements;
  }

  @override
  void buildStatus(String status) {
    _status = status;
  }

  @override
  Job getResult() {
    if (_id == null || _title == null || _description == null || _location == null) {
      throw Exception("Missing required Job fields");
    }

    return Job(
      id: _id!,
      title: _title!,
      description: _description!,
      location: _location!,
      status: _status,
      salary: _salary ?? '',
      requirements: _requirements ?? '',
    );
  }

  // Legacy methods for backward compatibility
  // These allow existing code to continue working while transitioning to the new pattern
  JobBuilder setId(String id) {
    buildId(id);
    return this;
  }

  JobBuilder setTitle(String title) {
    buildTitle(title);
    return this;
  }

  JobBuilder setDescription(String description) {
    buildDescription(description);
    return this;
  }

  JobBuilder setLocation(String location) {
    buildLocation(location);
    return this;
  }

  JobBuilder setStatus(String status) {
    buildStatus(status);
    return this;
  }

  JobBuilder setSalary(String salary) {
    buildSalary(salary);
    return this;
  }

  JobBuilder setRequirements(String requirements) {
    buildRequirements(requirements);
    return this;
  }

  Job build() {
    return getResult();
  }
}
