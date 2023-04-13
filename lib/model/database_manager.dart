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

  static Future<List<ListModel>> loadListModels() async {
    final loadedListModels = await isar.listModels.where().findAll();
    for (final listModel in loadedListModels) {
      listModel.init();
    }
    return loadedListModels;
  }

  static Future<ListModel> putListModel(ListModel listModel) async {
    await isar.writeTxn(() async => await isar.listModels.put(listModel));
    return listModel;
  }

  static Future<void> deleteListModel(ListModel listModel) async {
    late final bool wasDeleted;
    await isar.writeTxn(() async {
      await isar.items
          .deleteAll(listModel.items.map((item) => item.id).toList());
      wasDeleted = await isar.listModels.delete(listModel.id);
    });

    assert(wasDeleted);
  }

  static Future<void> updateListModelItems(ListModel which) async =>
      await isar.writeTxn(() async => await which.items.save());

  static Future<Item> putItem(Item item) async {
    await isar.writeTxn(() async => await isar.items.put(item));
    return item;
  }

  static Future<void> deleteItem(Item item) async =>
      await isar.writeTxn(() async => await isar.items.delete(item.id));
}
