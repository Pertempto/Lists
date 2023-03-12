import 'package:isar/isar.dart';
import 'package:lists/model/database_manager.dart';
import 'package:lists/model/item.dart';

part 'list_model.g.dart';

/// ListModel:
///   - this class models a list in the app, such as a
///     to-do list, a shopping list, etc.
@Collection()
class ListModel {
  Id id = Isar.autoIncrement;
  late String title;

  final items = IsarLinks<Item>();

  Iterable<Item> itemsView() => items;

  // a zero-arg constructor is required for classes that are isar collections
  ListModel();
  ListModel.fromTitle(this.title);

  void init() => items.loadSync();

  Future<void> addOrUpdate(Item newItem) async {
    await DatabaseManager.putItem(newItem);
    if (items.add(newItem)) {
      await DatabaseManager.updateListModelItems(this);
    }
  }

  Future<void> remove(Item item) async {
    if (items.remove(item)) {
      await DatabaseManager.deleteItem(item);
      await DatabaseManager.updateListModelItems(this);
    }
  }
}
