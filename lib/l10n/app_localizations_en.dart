// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Aura Control';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get robotIp => 'Robot IP';

  @override
  String get logs => 'Logs';

  @override
  String get categories => 'Categories';

  @override
  String get commands => 'Commands';

  @override
  String get execute => 'Execute';

  @override
  String get info => 'Info';

  @override
  String get warning => 'Warning';

  @override
  String get error => 'Error';

  @override
  String get all => 'All';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get english => 'English';

  @override
  String get spanish => 'Spanish';

  @override
  String get noConnection => 'Cannot connect to the robot. Please check the IP address and ensure the robot is powered on.';

  @override
  String get retryConnection => 'Retry Connection';

  @override
  String get editRobotIp => 'Edit Robot IP';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get sshUser => 'SSH User';

  @override
  String get sshPassword => 'SSH Password';

  @override
  String get editSshUser => 'Edit SSH User';

  @override
  String get editSshPassword => 'Edit SSH Password';

  @override
  String get remoteCommandsDir => 'Remote Commands Directory';

  @override
  String get editRemoteCommandsDir => 'Edit Remote Commands Directory';

  @override
  String get resetToDefaults => 'Reset to Defaults';

  @override
  String get resetConfirmation => 'Are you sure you want to reset all settings to their default values?';

  @override
  String get confirm => 'Confirm';

  @override
  String get pingInterval => 'Ping Interval';

  @override
  String get enterPingInterval => 'Enter Ping Interval';
}
