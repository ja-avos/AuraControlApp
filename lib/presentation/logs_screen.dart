import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/logger.dart';

class LogsScreen extends StatefulWidget {
  const LogsScreen({super.key});

  @override
  State<LogsScreen> createState() => _LogsScreenState();
}

class _LogsScreenState extends State<LogsScreen> {
  final ScrollController _scrollController = ScrollController();
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Info', 'Warning', 'Error'];
  List<String> _logs = [];
  bool _isAtBottom = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      final isAtBottom =
          _scrollController.offset >=
          _scrollController.position.maxScrollExtent;
      if (isAtBottom != _isAtBottom) {
        setState(() {
          _isAtBottom = isAtBottom;
        });
      }
    });
    _fetchLogs();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchLogs() async {
    final logger = Logger();
    final allLogs = await logger.readLogs();
    setState(() {
      _logs = allLogs;
    });
  }

  List<String> _applyFilter() {
    if (_selectedFilter == 'All') {
      return _logs;
    }
    return _logs.where((log) => log.contains('[$_selectedFilter]')).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredLogs = _applyFilter();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Logs'),
        actions: [
          DropdownButton<String>(
            value: _selectedFilter,
            items:
                _filters
                    .map(
                      (filter) =>
                          DropdownMenuItem(value: filter, child: Text(filter)),
                    )
                    .toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _selectedFilter = value;
                });
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Clear Logs'),
                    content: const Text(
                      'Are you sure you want to clear all logs?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Clear'),
                      ),
                    ],
                  );
                },
              );

              if (confirm == true) {
                await Logger().clearLogs();
                setState(() {
                  _logs = [];
                });
              }
            },
          ),
        ],
      ),
      body:
          filteredLogs.isEmpty
              ? const Center(child: Text('No logs available'))
              : ListView.builder(
                controller: _scrollController,
                itemCount: filteredLogs.length,
                itemBuilder: (context, index) {
                  return ListTile(title: Text(filteredLogs[index]));
                },
              ),
      floatingActionButton:
          _isAtBottom
              ? null
              : FloatingActionButton(
                onPressed: () {
                  if (_logs.isNotEmpty) {
                    _scrollController.animateTo(
                      _scrollController.position.maxScrollExtent,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                    );
                  }
                },
                child: const Icon(Icons.arrow_downward),
              ),
    );
  }
}
