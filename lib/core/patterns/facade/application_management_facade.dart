import '../../patterns/strategy/application_status_strategy.dart';
import '../../../data/model/job_application.dart';

class ApplicationManagementFacade {
  void updateStatus(
      JobApplication application, ApplicationStatusStrategy strategy) {
    application.status = strategy.getStatus();
  }
}
