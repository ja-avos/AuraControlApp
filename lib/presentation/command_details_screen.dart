import 'package:aura_control/domain/models/command.dart';
import 'package:aura_control/presentation/settings_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/logger.dart';
import 'categories_notifier.dart';
import '../domain/execute_command_usecase.dart';
import '../l10n/app_localizations.dart';
import '../core/constants.dart';

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
            appBar: AppBar(
              title: Text(AppLocalizations.of(context)!.commandDetails),
            ),
            body: const Center(child: CircularProgressIndicator()),
          );
        }
        final command = notifier.command;
        if (command == null) {
          return Scaffold(
            appBar: AppBar(
              title: Text(AppLocalizations.of(context)!.commandDetails),
            ),
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
          body: SingleChildScrollView(
            padding: kDefaultMargin,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        command.name,
                        style: const TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        "Description",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8.0),
                      const Divider(),
                      const SizedBox(height: 8.0),
                      Text(
                        command.description,
                        style: const TextStyle(fontSize: 16.0),
                      ),
                      const SizedBox(height: 16.0),
                      Text(
                        "All Properties",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8.0),
                      ...command.fields.entries.map(
                        (entry) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${entry.key}: ",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  entry.value.toString(),
                                  style: const TextStyle(fontSize: 16.0),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24.0),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => executeCommand(context, command),
            icon: const Icon(Icons.play_arrow),
            label: Text(AppLocalizations.of(context)!.execute),
          ),
        );
      },
    );
  }

  Future<void> executeCommand(BuildContext context, Command command) async {
    Logger().log(
      'Info',
      'Executing command from details screen',
      metadata: {'commandId': command.id, 'commandName': command.name},
    );
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.executingCommand)),
      );
      final result = await _executeCommandUseCase.execute(command);
      Logger().log(
        'Info',
        'Command executed successfully',
        metadata: {'result': result},
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${AppLocalizations.of(context)!.commandExecutedSuccessfully}: $result',
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
          content: Text(
            '${AppLocalizations.of(context)!.failedToExecuteCommand}: $e',
          ),
        ),
      );
    }
  }
}
