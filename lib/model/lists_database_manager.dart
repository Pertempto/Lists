import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:lists/model/list_model.dart';

/// DatabaseManager:
///   - a class that creates, reads, updates, and
///     destroys lists (see ListModel).
class ListsDatabaseManager {
  static late final Isar isar;

  static Future<void> init() async {
    if (Isar.instanceNames.isEmpty) {
      isar = await Isar.open([ListModelSchema], inspector: kDebugMode);
    }
  }

  static Future<ListModel> createListModel(String name) async {
    final newListModel = ListModel.fromName(name);
    await isar.writeTxn(() async => await isar.listModels.put(newListModel));
    return newListModel;
  }

  static Future<List<ListModel>> getAllListModels() async =>
      await isar.listModels.where().findAll();

  static Future<void> updateListModel(ListModel which) async =>
      await isar.writeTxn(() async => await isar.listModels.put(which));
}
