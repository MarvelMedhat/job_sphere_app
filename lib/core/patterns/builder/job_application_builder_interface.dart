import 'dart:typed_data';
import '../../../data/model/job_application.dart';

/// Abstract Builder interface for JobApplication construction
/// Defines all the building steps required to construct a JobApplication object
abstract class JobApplicationBuilderInterface {
  void buildId(String id);
  
  void buildApplicant(String applicantId);
  
  void buildJob(String jobId);
  
  void buildResumePath(String? path);
  
  void buildResumeBytes(Uint8List? bytes);
  
  void buildStatus(String status);
  
  /// Returns the constructed JobApplication object
  JobApplication getResult();
}
