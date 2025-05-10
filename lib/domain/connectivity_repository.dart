abstract class ConnectivityRepository {
  /// Checks if the robot is reachable via ping.
  Future<bool> isRobotReachable(String ipAddress);

  /// Monitors the network connectivity status.
  Stream<bool> get connectivityStream;
}
