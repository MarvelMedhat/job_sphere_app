import 'dart:typed_data';
import '../../../data/model/job_application.dart';

abstract class JobApplicationBuilderInterface {
  void buildId(String id);
  
  void buildApplicant(String applicantId);
  
  void buildJob(String jobId);
  
  void buildResumePath(String? path);
  
  void buildResumeBytes(Uint8List? bytes);
  
  void buildStatus(String status);

  JobApplication getResult();
}
