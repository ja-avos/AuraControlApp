import 'package:aura_control/domain/execute_command_usecase.dart';
import 'package:aura_control/presentation/settings_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'categories_notifier.dart';
import '../core/logger.dart';

const EdgeInsets _defaultMargin = EdgeInsets.symmetric(
  horizontal: 16.0,
  vertical: 8.0,
);

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  @override
  void initState() {
    super.initState();
    final notifier = context.read<CategoriesNotifier>();
    notifier.fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<CategoriesNotifier>();

    return Scaffold(
      appBar: AppBar(title: const Text('Categories')),
      body:
          notifier.isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: notifier.categories.length,
                itemBuilder: (context, index) {
                  final category = notifier.categories[index];
                  Logger().log(
                    'Info',
                    'Rendering category item',
                    metadata: {
                      'categoryId': category.id,
                      'categoryName': category.name,
                    },
                  );
                  return Card(
                    margin: _defaultMargin,
                    elevation: 4.0,
                    child: ListTile(
                      title: Text(
                        category.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                      onTap: () {
                        Logger().log(
                          'Info',
                          'Category selected',
                          metadata: {
                            'categoryId': category.id,
                            'categoryName': category.name,
                          },
                        );
                        context.push('/categories/${category.id}');
                      },
                    ),
                  );
                },
              ),
    );
  }
}

class CommandsScreen extends StatefulWidget {
  final String categoryId;

  const CommandsScreen({super.key, required this.categoryId});

  @override
  State<CommandsScreen> createState() => _CommandsScreenState();
}

class _CommandsScreenState extends State<CommandsScreen> {
  late final ExecuteCommandUseCase _executeCommandUseCase;

  @override
  void initState() {
    super.initState();
    _executeCommandUseCase = ExecuteCommandUseCase(
      context.read<SettingsNotifier>(),
    );
    final notifier = context.read<CategoriesNotifier>();
    notifier.fetchCommands(widget.categoryId);
  }

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<CategoriesNotifier>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          notifier.categories
              .firstWhere((category) => category.id == widget.categoryId)
              .name,
        ),
      ),
      body:
          notifier.isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: notifier.commands.length,
                itemBuilder: (context, index) {
                  final command = notifier.commands[index];
                  return Card(
                    margin: _defaultMargin,
                    child: ListTile(
                      title: Text(command.name),
                      subtitle: Text(command.description),
                      trailing: IconButton(
                        icon: const Icon(Icons.play_arrow),
                        onPressed: () async {
                          Logger().log(
                            'Info',
                            'Executing command',
                            metadata: {
                              'commandId': command.id,
                              'commandName': command.name,
                            },
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Executing command...'),
                            ),
                          );
                          await _executeCommandUseCase.execute(command);
                          Logger().log(
                            'Info',
                            'Command executed successfully',
                            metadata: {
                              'commandId': command.id,
                              'commandName': command.name,
                            },
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Command executed: ${command.name}',
                              ),
                            ),
                          );
                        },
                      ),
                      onTap: () {
                        context.push('/commands/${command.id}');
                      },
                    ),
                  );
                },
              ),
    );
  }
}
