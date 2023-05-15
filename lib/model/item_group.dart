import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:lists/model/database_manager.dart';
import 'package:lists/model/item.dart';
import 'package:lists/model/item_group_base.dart';
import 'package:lists/model/item_group_search_results.dart';

part 'item_group.g.dart';

@Collection()
class ItemGroup extends ItemGroupBase {
  Id id = Isar.autoIncrement;

  @override
  String? title;
  final items = IsarLinks<Item>();

  ItemGroup({this.title});

  @ignore
  @override
  int get itemCount => items.length;

  @override
  Iterable<Item> itemsView() => items;

  @override
  Future<ItemGroup> asDatabaseItemGroup() async => this;

  void init() {
    items.loadSync();
    for (final item in items) {
      item.init();
    }
  }

  Future<bool> add(Item newItem) async {
    await DatabaseManager.putItem(newItem);
    if (items.add(newItem)) {
      await DatabaseManager.updateGroupItems(this);
      await newItem.groupLink.load();
      return true;
    }
    return false;
  }

  Future<bool> contains(Item item) async => items.contains(item);

  Future<bool> remove(Item item) async {
    if (items.remove(item)) {
      await DatabaseManager.deleteItem(item);
      await DatabaseManager.updateGroupItems(item.group);
      return true;
    }
    return false;
  }

  Future<ItemGroupSearchResults> search(Iterable<String> searchWords) async =>
      ItemGroupSearchResults(
          group: this,
          results: await items
              .filter()
              .allOf(searchWords,
                  (q, word) => q.valueContains(word, caseSensitive: false))
              .findAll());
}
