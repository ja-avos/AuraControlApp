import 'dart:convert';
import 'models/command.dart';
import '../core/logger.dart';
import 'package:dartssh2/dartssh2.dart';
import '../presentation/settings_notifier.dart';

class ExecuteCommandUseCase {
  final SettingsNotifier _settingsNotifier;

  ExecuteCommandUseCase(this._settingsNotifier);

  Future<String> execute(Command command) async {
    final robotIp = _settingsNotifier.robotIp;
    final password = _settingsNotifier.sshPassword;

    try {
      Logger().log(
        'Info',
        'Connecting to robot via SSH',
        metadata: {'robotIp': robotIp},
      );

      final client = SSHClient(
        await SSHSocket.connect(robotIp, 22),
        username: _settingsNotifier.sshUser,
        onPasswordRequest: () => password,
      );

      Logger().log(
        'Info',
        'Connected to robot successfully',
        metadata: {'robotIp': robotIp, 'username': _settingsNotifier.sshUser},
      );

      // Determine the command to execute
      String commandToExecute = 'cd ${_settingsNotifier.remoteCommandsDir} && ';
      if (command.isBasic) {
        commandToExecute += 'python3 ${command.fileName} eth0';
      } else {
        commandToExecute += command.fileName;
      }

      Logger().log(
        'Info',
        'Executing command',
        metadata: {'command': commandToExecute},
      );

      // Execute the command
      final result = await client.run(commandToExecute);
      final output = utf8.decode(result); // Decode the Uint8List to a string

      client.close();

      Logger().log(
        'Info',
        'Command executed successfully',
        metadata: {'result': output},
      );

      return output;
    } catch (e) {
      Logger().log(
        'Error',
        'Failed to execute command',
        metadata: {'error': e.toString()},
      );
      throw Exception('Failed to execute command: ${command.name}');
    }
  }
}
