import 'dart:typed_data';
import 'job_application_builder_interface.dart';
import '../../../data/model/job_application.dart';

class JobApplicationDirector {
  final JobApplicationBuilderInterface _builder;

  JobApplicationDirector(this._builder);

  JobApplication constructWithResumePath({
    required String id,
    required String applicantId,
    required String jobId,
    required String resumePath,
    String status = "Pending",
  }) {
    _builder.buildId(id);
    _builder.buildApplicant(applicantId);
    _builder.buildJob(jobId);
    _builder.buildResumePath(resumePath);
    _builder.buildResumeBytes(null);
    _builder.buildStatus(status);
    
    return _builder.getResult();
  }

  JobApplication constructWithResumeBytes({
    required String id,
    required String applicantId,
    required String jobId,
    required Uint8List resumeBytes,
    String status = "Pending",
  }) {
    _builder.buildId(id);
    _builder.buildApplicant(applicantId);
    _builder.buildJob(jobId);
    _builder.buildResumePath(null);
    _builder.buildResumeBytes(resumeBytes);
    _builder.buildStatus(status);
    
    return _builder.getResult();
  }

  JobApplication constructBasic({
    required String id,
    required String applicantId,
    required String jobId,
    String status = "Pending",
  }) {
    _builder.buildId(id);
    _builder.buildApplicant(applicantId);
    _builder.buildJob(jobId);
    _builder.buildResumePath(null);
    _builder.buildResumeBytes(null);
    _builder.buildStatus(status);
    
    return _builder.getResult();
  }

  JobApplication constructComplete({
    required String id,
    required String applicantId,
    required String jobId,
    String? resumePath,
    Uint8List? resumeBytes,
    String status = "Pending",
  }) {
    _builder.buildId(id);
    _builder.buildApplicant(applicantId);
    _builder.buildJob(jobId);
    _builder.buildResumePath(resumePath);
    _builder.buildResumeBytes(resumeBytes);
    _builder.buildStatus(status);
    
    return _builder.getResult();
  }
}
