import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/logger.dart';
import '../data/settings_repository_impl.dart';

class SettingsNotifier extends ChangeNotifier {
  final SettingsRepositoryImpl _repository;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  String _language = 'English';
  String get language => _language;

  String _robotIp = '';
  String get robotIp => _robotIp;

  String _sshUser = '';
  String get sshUser => _sshUser;

  String _sshPassword = '';
  String get sshPassword => _sshPassword;

  String _remoteCommandsDir = '';
  String get remoteCommandsDir => _remoteCommandsDir;

  int _pingInterval = 5; // Default value in seconds
  int get pingInterval => _pingInterval;

  SettingsNotifier(this._repository);

  Future<void> fetchSettings() async {
    _isLoading = true;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      // Check if local settings exist
      if (prefs.containsKey('isDarkMode') &&
          prefs.containsKey('language') &&
          prefs.containsKey('robotIp') &&
          prefs.containsKey('sshUser') &&
          prefs.containsKey('sshPassword') &&
          prefs.containsKey('remoteCommandsDir') &&
          prefs.containsKey('pingInterval')) {
        _isDarkMode = prefs.getBool('isDarkMode') ?? false;
        _language = prefs.getString('language') ?? 'English';
        _robotIp = prefs.getString('robotIp') ?? '';
        _sshUser = prefs.getString('sshUser') ?? '';
        _sshPassword = prefs.getString('sshPassword') ?? '';
        _remoteCommandsDir = prefs.getString('remoteCommandsDir') ?? '';
        _pingInterval = prefs.getInt('pingInterval') ?? 5;
        Logger().log('Info', 'Settings loaded from local storage');
      } else {
        // Fetch from Firestore if no local settings
        final settings = await _repository.fetchSettings();
        _isDarkMode = settings['isDarkMode'] ?? false;
        _language = settings['language'] ?? 'English';
        _robotIp = settings['robotIp'] ?? '';
        _sshUser = settings['sshUser'] ?? '';
        _sshPassword = settings['sshPassword'] ?? '';
        _remoteCommandsDir = settings['remoteCommandsDir'] ?? '';
        _pingInterval = settings['pingInterval'] ?? 5;
        Logger().log('Info', 'Settings fetched from Firestore');
        // Save fetched settings locally
        await prefs.setBool('isDarkMode', _isDarkMode);
        await prefs.setString('language', _language);
        await prefs.setString('robotIp', _robotIp);
        await prefs.setString('sshUser', _sshUser);
        await prefs.setString('sshPassword', _sshPassword);
        await prefs.setString('remoteCommandsDir', _remoteCommandsDir);
        await prefs.setInt('pingInterval', _pingInterval);
        Logger().log('Info', 'Settings saved to local storage');
      }
    } catch (e) {
      Logger().log(
        'Error',
        'Failed to fetch settings',
        metadata: {'error': e.toString()},
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void updateDarkMode(bool value) async {
    _isDarkMode = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', value);
    Logger().log('Info', 'Dark mode updated locally');
  }

  void toggleDarkMode(bool isDarkMode) async {
    _isDarkMode = isDarkMode;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', _isDarkMode);
    Logger().log('Info', 'Dark mode updated to: $_isDarkMode');
  }

  void updateLanguage(String newLanguage) async {
    _language = newLanguage;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', _language);
    notifyListeners();
  }

  void updateRobotIp(String value) async {
    _robotIp = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('robotIp', value);
    Logger().log('Info', 'Robot IP updated locally');
  }

  void updateSshUser(String value) async {
    _sshUser = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('sshUser', value);
    Logger().log('Info', 'SSH user updated locally');
  }

  void updateSshPassword(String value) async {
    _sshPassword = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('sshPassword', value);
    Logger().log('Info', 'SSH password updated locally');
  }

  void updateRemoteCommandsDir(String value) async {
    _remoteCommandsDir = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('remoteCommandsDir', value);
    Logger().log('Info', 'Remote commands directory updated locally');
  }

  void updatePingInterval(int value) async {
    _pingInterval = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('pingInterval', value);
    Logger().log('Info', 'Ping interval updated locally');
  }

  Future<void> resetToDefaults() async {
    _isLoading = true;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      // Delete all keys from local storage
      await prefs.remove('isDarkMode');
      await prefs.remove('language');
      await prefs.remove('robotIp');
      await prefs.remove('sshUser');
      await prefs.remove('sshPassword');
      await prefs.remove('remoteCommandsDir');
      await prefs.remove('pingInterval');

      await fetchSettings();

      Logger().log('Info', 'Settings reset to defaults from Firestore');
    } catch (e) {
      Logger().log(
        'Error',
        'Failed to reset settings to defaults',
        metadata: {'error': e.toString()},
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
