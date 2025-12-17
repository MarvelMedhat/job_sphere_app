import 'dart:typed_data';
import 'job_application_builder_interface.dart';
import '../../../data/model/job_application.dart';

/// Director class for JobApplication construction
/// Orchestrates the construction process using a JobApplicationBuilderInterface
/// Provides different standardized construction workflows
class JobApplicationDirector {
  final JobApplicationBuilderInterface _builder;

  JobApplicationDirector(this._builder);

  /// Constructs a job application with a resume file path
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

  /// Constructs a job application with resume bytes (for web platform)
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

  /// Constructs a basic job application without resume
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

  /// Constructs a complete job application with all available data
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
