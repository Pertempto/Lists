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

  void add(Item newItem) {
    if (items.add(newItem)) {
      isar.writeTxnSync(() => isar.items.putSync(newItem));
    }
  }

  void remove(Item item) {
    if (items.remove(item)) {
      isar.writeTxnSync(() => isar.items.deleteSync(item.id));
    }
  }

  Future<void> updateItems() async => await items.save();

  void updateItemValue(Item item) {}
}
