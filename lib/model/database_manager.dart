import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:lists/model/item.dart';
import 'package:lists/model/list_model.dart';

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

  static Future<List<ListModel>> getAllListModels() async =>
      (await isar.listModels.where().findAll())..forEach((e) => e.init());

  static Future<void> updateListModelItems(ListModel which) async =>
      await isar.writeTxn(() async => await which.updateItems());

  static Future<Item> createItem([String value = 'New Item']) async {
    final newItem = Item(value);
    await isar.writeTxn(() async => await isar.items.put(newItem));
    return newItem;
  }
}
