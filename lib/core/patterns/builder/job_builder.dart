import '../../../data/model/job.dart';

class JobBuilder {
  String? _id;
  String? _title;
  String? _description;
  String? _location;
  String _status = "Active";

  JobBuilder setId(String id) {
    _id = id;
    return this;
  }

  JobBuilder setTitle(String title) {
    _title = title;
    return this;
  }

  JobBuilder setDescription(String description) {
    _description = description;
    return this;
  }

  JobBuilder setLocation(String location) {
    _location = location;
    return this;
  }

  JobBuilder setStatus(String status) {
    _status = status;
    return this;
  }

  Job build() {
    return Job(
      id: _id!,
      title: _title!,
      description: _description!,
      location: _location!,
      status: _status, salary: '', requirements: '',
    );
  }
}
