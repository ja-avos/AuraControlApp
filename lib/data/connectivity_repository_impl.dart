import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../domain/connectivity_repository.dart';

class ConnectivityRepositoryImpl implements ConnectivityRepository {
  final Connectivity _connectivity;

  ConnectivityRepositoryImpl(this._connectivity);

  @override
  Future<bool> isRobotReachable(String ipAddress) async {
    try {
      final result = await Process.run('ping', ['-c', '1', ipAddress]);
      return result.exitCode == 0;
    } catch (e) {
      return false;
    }
  }

  @override
  Stream<bool> get connectivityStream => _connectivity.onConnectivityChanged
      .map((status) => status != ConnectivityResult.none);
}
