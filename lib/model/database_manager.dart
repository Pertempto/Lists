import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:lists/model/list_model.dart';
import 'package:lists/model/item.dart';

/// DatabaseManager:
///   - a class that creates, reads, updates, and
///     destroys lists (see ListModel).
class DatabaseManager {
  static late final Isar isar;
  static late _Cache _cache;

  static Iterable<ListModel> get listModels => _cache;

  static Future<void> init() async {
    if (Isar.instanceNames.isEmpty) {
      isar =
          await Isar.open([ListModelSchema, ItemSchema], inspector: kDebugMode);
      await _loadListModels();
    }
  }

  static Future<void> _loadListModels() async =>
      _cache = _Cache.fromList((await isar.listModels.where().findAll()));

  static Future<ListModel> putListModel(ListModel listModel) async {
    await isar.writeTxn(() async => await isar.listModels.put(listModel));

    if (_cache.isCached(listModel)) {
      _cache.updateListModel(listModel);
    } else {
      _cache.addListModel(listModel);
    }
    return listModel..init();
  }

  static Future<void> deleteListModel(ListModel listModel) async {
    late final bool wasDeleted;
    await isar.writeTxn(
        () async => wasDeleted = await isar.listModels.delete(listModel.id));

    assert(wasDeleted);
    _cache.deleteListModel(listModel);
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

class _Cache extends Iterable<ListModel> {
  final Set<ListModel> _cache;

  @override
  Iterator<ListModel> get iterator => _cache.iterator;

  _Cache.fromList(List<ListModel> listModels)
      : _cache = Set.of(listModels..forEach((listModel) => listModel.init()));

  void addListModel(ListModel listModel) {
    assert(!isCached(listModel));

    _cache.add(listModel);
  }

  void updateListModel(ListModel listModel) {
    assert(isCached(listModel));

    // We need to remove the old version of the listModel in _cache
    // before inserting the updated version. Otherwise else, the add
    // is a no-op and the update does not get registered.
    _cache
      ..remove(listModel)
      ..add(listModel);
  }

  void deleteListModel(ListModel listModel) {
    assert(isCached(listModel)); // assertion for debugging; no-op in release.
    _cache.remove(listModel);
  }

  bool isCached(ListModel listModel) => _cache.contains(listModel);
}
