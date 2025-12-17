import 'package:flutter_application_1/core/patterns/strategy/application_status_strategy.dart';

class ApplicationStatusContext {
  ApplicationStatusStrategy _strategy;

  ApplicationStatusContext(this._strategy);

  void setStrategy(ApplicationStatusStrategy strategy) {
    _strategy = strategy;
  }

  String getStatus() {
    return _strategy.getStatus();
  }
}
