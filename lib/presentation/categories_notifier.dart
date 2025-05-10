import 'package:flutter/material.dart';
import '../domain/categories_repository.dart';
import '../domain/models/category.dart';
import '../domain/models/command.dart';
import '../core/logger.dart';

class CategoriesNotifier extends ChangeNotifier {
  final CategoriesRepository _repository;

  CategoriesNotifier(this._repository);

  List<Category> _categories = [];
  List<Category> get categories => _categories;

  List<Command> _commands = [];
  List<Command> get commands => _commands;

  Command? _command;
  Command? get command => _command;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchCategories() async {
    Logger().log('Info', 'Notifier: Fetching categories');
    _isLoading = true;
    notifyListeners();
    try {
      _categories = await _repository.fetchCategories();
      Logger().log(
        'Info',
        'Notifier: Categories fetched successfully',
        metadata: {'count': _categories.length},
      );
    } catch (e) {
      Logger().log(
        'Error',
        'Notifier: Failed to fetch categories',
        metadata: {'error': e.toString()},
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchCommands(String categoryId) async {
    Logger().log(
      'Info',
      'Notifier: Fetching commands for category',
      metadata: {'categoryId': categoryId},
    );
    _isLoading = true;
    notifyListeners();
    try {
      _commands = await _repository.fetchCommands(categoryId);
      Logger().log(
        'Info',
        'Notifier: Commands fetched successfully',
        metadata: {'categoryId': categoryId, 'count': _commands.length},
      );
    } catch (e) {
      Logger().log(
        'Error',
        'Notifier: Failed to fetch commands',
        metadata: {'categoryId': categoryId, 'error': e.toString()},
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fetch command by id and set it to the command variable. Note that list of commands should be fetched before
  Future<void> fetchCommandById(String commandId) async {
    Logger().log(
      'Info',
      'Notifier: Fetching command by ID',
      metadata: {'commandId': commandId},
    );
    _isLoading = true;
    notifyListeners();
    try {
      _command = _commands.firstWhere((cmd) => cmd.id == commandId);
      Logger().log(
        'Info',
        'Notifier: Command fetched successfully',
        metadata: {'commandId': _command!.id},
      );
    } catch (e) {
      Logger().log(
        'Error',
        'Notifier: Failed to fetch command by ID',
        metadata: {'commandId': commandId, 'error': e.toString()},
      );
      _command = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
