import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';

class Logger {
  static final Logger _instance = Logger._internal();
  late File _logFile;
  late FirebaseFirestore _firestore;

  factory Logger() {
    return _instance;
  }

  Logger._internal();

  Future<void> init() async {
    final directory = await getApplicationDocumentsDirectory();
    _logFile = File('${directory.path}/app_logs.txt');
    _firestore = FirebaseFirestore.instance;
  }

  Future<void> log(
    String level,
    String message, {
    Map<String, dynamic>? metadata,
  }) async {
    final timestamp = DateTime.now().toIso8601String();
    final logEntry = '[$timestamp][$level] $message\n';

    try {
      // Write to local file
      await _logFile.writeAsString(logEntry, mode: FileMode.append);
    } catch (e) {
      print('Failed to write log to file: $e');
    }

    try {
      // Write to Firebase
      await _firestore.collection('app_logs').add({
        'timestamp': timestamp,
        'level': level,
        'message': message,
        'metadata': metadata ?? {},
      });
    } catch (e) {
      print('Failed to write log to Firebase: $e');
    }

    // Print to Flutter debug console
    print(logEntry);
  }

  Future<List<String>> readLogs() async {
    if (await _logFile.exists()) {
      return await _logFile.readAsLines();
    }
    return [];
  }

  Future<void> clearLogs() async {
    try {
      if (await _logFile.exists()) {
        await _logFile.writeAsString('');
        print('Logs cleared successfully.');
      }
    } catch (e) {
      print('Failed to clear logs: $e');
    }
  }
}
