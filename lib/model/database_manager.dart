import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:lists/model/item_group_base.dart';
import 'package:lists/model/list_model.dart';
import 'package:lists/model/item.dart';
import 'package:lists/model/item_group.dart';

/// DatabaseManager:
///   - a class that creates, reads, updates, and
///     destroys lists (see ListModel).
class DatabaseManager {
  static late final Isar isar;

  static Future<void> init() async {
    if (Isar.instanceNames.isEmpty) {
      isar = await Isar.open([ListModelSchema, ItemSchema, ItemGroupSchema],
          inspector: kDebugMode);
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
    await listModel.ensureHasDefaultItemGroup();
    return listModel;
  }

  static Future<void> deleteListModel(ListModel listModel) async {
    late final bool wasDeleted;

    for (final itemGroup in listModel.groupsView()) {
      deleteItemGroup(itemGroup);
    }
    await isar.writeTxn(
        () async => wasDeleted = await isar.listModels.delete(listModel.id));

    assert(wasDeleted);
  }

  static Future<void> updateListModelGroups(ListModel listModel) async {
    await isar.writeTxn(() async {
      await listModel.defaultItemGroupLink.save();
      await listModel.itemGroups.save();
    });
  }

  static Future<ItemGroup> putItemGroup(ItemGroup itemGroup) async {
    await isar.writeTxn(() async => await isar.itemGroups.put(itemGroup));
    return itemGroup;
  }

  static Future<void> deleteItemGroup(ItemGroup itemGroup) async {
    await isar.writeTxn(() async {
      await isar.items
          .deleteAll(itemGroup.items.map((item) => item.id).toList());

      await isar.itemGroups.delete(itemGroup.id);
    });
  }

  static Future<void> moveItems(
      {required ItemGroup from, required ItemGroup to}) async {
    to.items.addAll(from.items);
    from.items.clear();
    await updateGroupItems(from);
    await updateGroupItems(to);
  }

  static Future<void> updateGroupItems(ItemGroup which) async {
    await isar.writeTxn(() async => await which.items.save());
  }

  static Future<Item> putItem(Item item) async {
    await isar.writeTxn(() async => await isar.items.put(item));
    return item;
  }

  static Future<void> deleteItem(Item item) async =>
      await isar.writeTxn(() async => await isar.items.delete(item.id));
}
