import 'package:flutter_application_1/core/patterns/strategy/application_status_context.dart';

import '../../patterns/strategy/application_status_strategy.dart';
import '../../../data/model/job_application.dart';

class ApplicationManagementFacade {
  void updateStatus(
    JobApplication application,
    ApplicationStatusStrategy strategy,
  ) {
    final context = ApplicationStatusContext(strategy);
    application.status = context.getStatus();
  }
}
