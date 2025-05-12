import 'package:cloud_firestore/cloud_firestore.dart';

class Command {
  final String id;
  final String name;
  final String description;
  final String fileName;
  final bool isBasic;

  Command({
    required this.id,
    required this.name,
    required this.description,
    required this.fileName,
    required this.isBasic,
  });

  factory Command.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Command(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      fileName: data['fileName'] ?? '',
      isBasic: data['isBasic'] ?? true,
    );
  }

  Map<String, dynamic> get fields => {
    'id': id,
    'name': name,
    'description': description,
    'fileName': fileName,
    'isBasic': isBasic,
  };
}
