import 'package:isar/isar.dart';
import 'package:lists/model/list_model.dart';

/// DatabaseManager:
///   - a class that creates, reads, updates, and
///     destroys lists.
class ListsDatabaseManager {
  static late final Isar isar;

  static Future<void> init() async {
    if (Isar.instanceNames.isEmpty) {
      isar = await Isar.open([ListModelSchema], inspector: true);
    }
  }

  static Future<ListModel> createListModel(String name) async {
    final newListModel = ListModel.make(name: name);
    await isar.writeTxn(() async => await isar.listModels.put(newListModel));
    return newListModel;
  }

  static Future<List<ListModel>> getAllListModels() async =>
      await isar.listModels.where().findAll();

  static Future<void> update(ListModel which) async =>
      await isar.writeTxn(() async => await isar.listModels.put(which));
}
