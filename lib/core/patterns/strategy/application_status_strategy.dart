abstract class ApplicationStatusStrategy {
  String getStatus();
}

class AcceptedStatus implements ApplicationStatusStrategy {
  @override
  String getStatus() => "Accepted";
}

class RejectedStatus implements ApplicationStatusStrategy {
  @override
  String getStatus() => "Rejected";
}

class PendingStatus implements ApplicationStatusStrategy {
  @override
  String getStatus() => "Pending";
}

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
