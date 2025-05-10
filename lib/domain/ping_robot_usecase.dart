import 'connectivity_repository.dart';

class PingRobotUseCase {
  final ConnectivityRepository repository;

  PingRobotUseCase(this.repository);

  Future<bool> execute(String ipAddress) {
    return repository.isRobotReachable(ipAddress);
  }
}
