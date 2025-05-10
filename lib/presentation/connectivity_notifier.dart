import 'dart:async';
import 'package:flutter/material.dart';
import '../domain/ping_robot_usecase.dart';
import '../core/logger.dart';
import '../presentation/settings_notifier.dart';

class ConnectivityNotifier extends ChangeNotifier {
  final PingRobotUseCase _pingRobotUseCase;
  final SettingsNotifier _settingsNotifier;

  bool _isConnected = false;
  bool get isConnected => _isConnected;

  Timer? _timer;

  ConnectivityNotifier(this._pingRobotUseCase, this._settingsNotifier) {
    _settingsNotifier.addListener(_onSettingsChanged);
    _onSettingsChanged();
  }

  void _onSettingsChanged() {
    stopMonitoring();
    startMonitoring();
  }

  void startMonitoring() {
    final pingInterval = Duration(seconds: _settingsNotifier.pingInterval);
    _timer = Timer.periodic(pingInterval, (_) async {
      await _checkConnectivity(_settingsNotifier.robotIp);
    });
  }

  void stopMonitoring() {
    _timer?.cancel();
  }

  /// Checks the connectivity status of the robot.
  Future<void> checkConnectivity() async {
    final robotIp = _settingsNotifier.robotIp;
    await _checkConnectivity(robotIp);
  }

  Future<void> _checkConnectivity(String robotIp) async {
    final result = await _pingRobotUseCase.execute(robotIp);
    if (result != _isConnected) {
      _isConnected = result;
      notifyListeners();
      Logger().log(
        'Info',
        'Connectivity status changed',
        metadata: {
          'isConnected': _isConnected,
          'robotIp': robotIp,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
    } else {
      Logger().log(
        'Info',
        'Connectivity status unchanged',
        metadata: {
          'isConnected': _isConnected,
          'robotIp': robotIp,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
    }
  }

  @override
  void dispose() {
    _settingsNotifier.removeListener(_onSettingsChanged);
    stopMonitoring();
    super.dispose();
  }
}
