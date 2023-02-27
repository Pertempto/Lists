import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:lists/model/list_model.dart';

/// DatabaseManager:
///   - a class that creates, reads, updates, and
///     destroys lists (see ListModel).
class DatabaseManager {
  static late final Isar isar;
  static late final Set<ListModel> _listModelsCache;

  static UnmodifiableSetView<ListModel> get listModels =>
      UnmodifiableSetView(_listModelsCache);

  static Future<void> init() async {
    if (Isar.instanceNames.isEmpty) {
      isar = await Isar.open([ListModelSchema], inspector: kDebugMode);
      await _loadListModels();
    }
  }

  static Future<ListModel> createListModel(String title) async {
    final newListModel = ListModel.fromTitle(title);
    await isar.writeTxn(() async => await isar.listModels.put(newListModel));
    _listModelsCache.add(newListModel);
    return newListModel;
  }

  static Future<void> _loadListModels() async =>
      _listModelsCache = (await isar.listModels.where().findAll()).toSet();

  static Future<void> updateListModel(ListModel which) async => await isar
              .listModels
              .get(which.id) !=
          null
      ? await isar.writeTxn(() async => await isar.listModels.put(which))
      : _throw(
          "DatabaseManager: Error, list model titled '${which.title}' with id ${which.id} is not in this database. Can't update.");

  static Future<void> deleteListModel(ListModel which) async {
    _listModelsCache.remove(which);
    await isar.writeTxn(() async => await isar.listModels.delete(which.id));
  }
}

Never _throw(String s) => throw Exception(s);
