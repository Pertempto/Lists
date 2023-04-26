import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:lists/model/list_model.dart';
import 'package:lists/model/item.dart';
import 'package:lists/model/item_group.dart';
import 'package:lists/model/user_created_item_group.dart';

/// DatabaseManager:
///   - a class that creates, reads, updates, and
///     destroys lists (see ListModel).
class DatabaseManager {
  static late final Isar isar;

  static Future<void> init() async {
    if (Isar.instanceNames.isEmpty) {
      isar = await Isar.open(
          [ListModelSchema, ItemSchema, UserCreatedItemGroupSchema],
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
    return listModel;
  }

  static Future<void> deleteListModel(ListModel listModel) async {
    late final bool wasDeleted;

    deleteItemGroup(listModel.defaultItemGroup);
    for (final itemGroup in listModel.userCreatedItemGroups) {
      deleteItemGroup(itemGroup);
    }
    await isar.writeTxn(
        () async => wasDeleted = await isar.listModels.delete(listModel.id));

    assert(wasDeleted);
  }

  static Future<ItemGroup> putUserCreatedItemGroup(
      UserCreatedItemGroup itemGroup) async {
    await isar
        .writeTxn(() async => await isar.userCreatedItemGroups.put(itemGroup));
    return itemGroup;
  }

  static Future<void> deleteItemGroup(ItemGroup itemGroup) async {
    await isar.writeTxn(() async {
      await isar.items
          .deleteAll(itemGroup.items.map((item) => item.id).toList());

      if (itemGroup is UserCreatedItemGroup) {
        await isar.userCreatedItemGroups.delete(itemGroup.id);
      }
    });
  }

  static Future<void> moveItems(
      {required ItemGroup from, required ItemGroup to}) async {
    to.items.addAll(from.items);
    from.items.clear();
    await isar.writeTxn(() async {
      await to.items.save();
      await from.items.save();
    });
  }

  static Future<void> updateGroupItems(ItemGroup which) async =>
      await isar.writeTxn(() async => await which.items.save());

  static Future<Item> putItem(Item item) async {
    await isar.writeTxn(() async => await isar.items.put(item));
    return item;
  }

  static Future<void> deleteItem(Item item) async =>
      await isar.writeTxn(() async => await isar.items.delete(item.id));
}
