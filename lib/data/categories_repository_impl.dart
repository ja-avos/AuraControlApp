import 'package:cloud_firestore/cloud_firestore.dart';
import '../core/logger.dart';
import '../domain/categories_repository.dart';
import '../domain/models/category.dart';
import '../domain/models/command.dart';

class CategoriesRepositoryImpl implements CategoriesRepository {
  final FirebaseFirestore _firestore;

  CategoriesRepositoryImpl(this._firestore);

  @override
  Future<List<Category>> fetchCategories() async {
    Logger().log('Info', 'Fetching categories from Firestore');
    try {
      final snapshot = await _firestore.collection('categories').get();
      Logger().log(
        'Info',
        'Categories fetched successfully',
        metadata: {'count': snapshot.docs.length},
      );
      return snapshot.docs.map((doc) => Category.fromFirestore(doc)).toList();
    } catch (e) {
      Logger().log(
        'Error',
        'Failed to fetch categories',
        metadata: {'error': e.toString()},
      );
      rethrow;
    }
  }

  @override
  Future<List<Command>> fetchCommands(String categoryId) async {
    Logger().log(
      'Info',
      'Fetching commands for category',
      metadata: {'categoryId': categoryId},
    );
    try {
      final snapshot =
          await _firestore
              .collection('categories')
              .doc(categoryId)
              .collection('commands')
              .get();
      Logger().log(
        'Info',
        'Commands fetched successfully',
        metadata: {'categoryId': categoryId, 'count': snapshot.docs.length},
      );
      return snapshot.docs.map((doc) => Command.fromFirestore(doc)).toList();
    } catch (e) {
      Logger().log(
        'Error',
        'Failed to fetch commands',
        metadata: {'categoryId': categoryId, 'error': e.toString()},
      );
      rethrow;
    }
  }
}
