import 'models/category.dart';
import 'models/command.dart';

abstract class CategoriesRepository {
  Future<List<Category>> fetchCategories();
  Future<List<Command>> fetchCommands(String categoryId);
}
