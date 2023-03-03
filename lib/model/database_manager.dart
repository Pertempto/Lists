import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:lists/model/list_model.dart';
import 'package:lists/model/item.dart';

/// DatabaseManager:
///   - a class that creates, reads, updates, and
///     destroys lists (see ListModel).
class DatabaseManager {
  static late final Isar isar;

  static Future<void> init() async {
    if (Isar.instanceNames.isEmpty) {
      isar =
          await Isar.open([ListModelSchema, ItemSchema], inspector: kDebugMode);
    }
  }

  static Future<ListModel> createListModel(String name) async {
    final newListModel = ListModel.fromTitle(name);
    await isar.writeTxn(() async => await isar.listModels.put(newListModel));
    return newListModel..init();
  }

  static Future<Item> createItem([String value = 'New Item']) async {
    final newItem = Item(value);
    await putItem(newItem);
    return newItem;
  }

  static Future<void> putItem(Item item) async =>
      await isar.writeTxn(() async => await isar.items.put(item));

  static Future<void> deleteItem(Item item) async =>
      await isar.writeTxn(() async => await isar.items.delete(item.id));

  static Future<List<ListModel>> getAllListModels() async =>
      (await isar.listModels.where().findAll())
        ..forEach((listModel) => listModel.init());

  static Future<void> updateListModelItems(ListModel which) async =>
      await isar.writeTxn(() async => await which.updateItems());
}
