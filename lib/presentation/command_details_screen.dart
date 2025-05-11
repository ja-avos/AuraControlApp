import 'package:aura_control/presentation/settings_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/logger.dart';
import 'categories_notifier.dart';
import '../domain/execute_command_usecase.dart';

class CommandDetailsScreen extends StatefulWidget {
  final String commandId;

  const CommandDetailsScreen({super.key, required this.commandId});

  @override
  _CommandDetailsScreenState createState() => _CommandDetailsScreenState();
}

class _CommandDetailsScreenState extends State<CommandDetailsScreen> {
  late final ExecuteCommandUseCase _executeCommandUseCase;

  @override
  void initState() {
    super.initState();
    final notifier = context.read<CategoriesNotifier>();
    notifier.fetchCommandById(widget.commandId);
    _executeCommandUseCase = ExecuteCommandUseCase(
      context.read<SettingsNotifier>(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoriesNotifier>(
      builder: (context, notifier, child) {
        if (notifier.isLoading) {
          return Scaffold(
            appBar: AppBar(title: const Text('Command Details')),
            body: const Center(child: CircularProgressIndicator()),
          );
        }
        final command = notifier.command;
        if (command == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Command Details')),
            body: const Center(
              child: Text(
                'Command not found',
                style: TextStyle(fontSize: 16.0),
              ),
            ),
          );
        }

        Logger().log(
          'Info',
          'Navigated to Command Details Screen',
          metadata: {'commandId': command.id, 'commandName': command.name},
        );

        return Scaffold(
          appBar: AppBar(title: Text(command.name)),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  command.name,
                  style: const TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  command.description,
                  style: const TextStyle(fontSize: 16.0),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton.icon(
                  onPressed: () async {
                    Logger().log(
                      'Info',
                      'Executing command from details screen',
                      metadata: {
                        'commandId': command.id,
                        'commandName': command.name,
                      },
                    );
                    try {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Executing command...')),
                      );
                      final result = await _executeCommandUseCase.execute(
                        command,
                      );
                      Logger().log(
                        'Info',
                        'Command executed successfully',
                        metadata: {'result': result},
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Command executed successfully: $result',
                          ),
                        ),
                      );
                    } catch (e) {
                      Logger().log(
                        'Error',
                        'Failed to execute command',
                        metadata: {'error': e.toString()},
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Failed to execute command: $e'),
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Execute Command'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
