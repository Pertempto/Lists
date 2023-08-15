import 'dart:math';

import 'package:collection/collection.dart';
import 'package:isar/isar.dart';
import 'package:lists/model/database_manager.dart';
import 'package:lists/model/item.dart';

part 'list_model.g.dart';

/// ListModel:
///   - this class models a list in the app, such as a
///     to-do list, a shopping list, etc.
@Collection()
class ListModel {
  Id id = Isar.autoIncrement;
  String title = '';

  final items = IsarLinks<Item>();
  List<String> labels = [];

  @ignore
  ItemType get lastItemType => items.lastOrNull?.itemType ?? ItemType.text;

  @ignore
  int get itemCount => items.length;
  Iterable<Item> itemsView() => items;

  // a zero-arg constructor is required for classes that are isar collections
  ListModel();
  ListModel.fromTitle(this.title) : labels = [];

  void init() {
    reload();
    // This ensures that labels is mutable
    labels = labels.toList();
  }

  void reload() => items.loadSync();

  Future<Iterable<Item>> searchItems(String searchQuery) {
    final words = _parseSearchStr(searchQuery);
    return items
        .filter()
        .allOf(words, (q, word) => q.valueContains(word, caseSensitive: false))
        .findAll();
  }

  Iterable<String> _parseSearchStr(String searchQuery) => RegExp(r"([^\s]+)")
      .allMatches(searchQuery)
      .map((match) => match.group(0)!);
  // note: the above regex pattern "([^\s]+)" matches a string without spaces.
  // All-in-all, this function breaks a sentence apart into words (though
  // it doesn't filter out punctuation).
  // example:
  // "The  great,    blue sky!?!? #@  " --> ["The", "great,", "blue", "sky!?!?", "#@"]

  Future<void> add(Item newItem) async {
    newItem.order = itemCount;
    await DatabaseManager.putItem(newItem);
    if (items.add(newItem)) {
      await DatabaseManager.updateListModelItems(this);
    }
  }

  Future<void> update(Item item) async {
    if (items.contains(item)) {
      await DatabaseManager.putItem(item);
      // The following ensures that the copy of `item` that `this` has is up to date.
      item.copyOnto(lookup(item));
    } else {
      throw ItemUpdateError(item: item, listModel: this);
    }
  }

  Future<void> remove(Item item) async {
    if (items.remove(item)) {
      final itemsOrderedAfterRemovedItem =
          await items.filter().orderGreaterThan(item.order).findAll();
      for (final item in itemsOrderedAfterRemovedItem) {
        --item.order;
      }

      await DatabaseManager.deleteItem(item);
      await DatabaseManager.putItems(itemsOrderedAfterRemovedItem);
      await DatabaseManager.updateListModelItems(this);
    }
  }

  Item lookup(Item item) => items.lookup(item)!;

  void reorderItem({required int oldOrder, required int newOrder}) {
    assert(oldOrder < items.length && oldOrder >= 0);
    assert(newOrder < items.length && newOrder >= 0);

    int lower = min(oldOrder, newOrder);
    int upper = max(oldOrder, newOrder);

    final itemsToReorder = items
        .filter()
        .orderBetween(lower, upper)
        .findAllSync()
        // lookup all the items so that the new orderings are instantly/synchronously reflected
        // in the `IsarLinks` copy of the database items.
        .map((item) => lookup(item));
    // note: we can use `findFirst` since there should be exactly one
    // element ordered with `oldOrder`.
    final itemWithOldOrder =
        lookup(items.filter().orderEqualTo(oldOrder).findFirstSync()!);
    final reorderingOffset = (oldOrder - newOrder).sign;

    for (final item in itemsToReorder) {
      item.order += reorderingOffset;
    }

    itemWithOldOrder.order = newOrder;
    DatabaseManager.putItems([...itemsToReorder, itemWithOldOrder]);
  }

  bool hasLabel(String label) => labels.contains(label);
}

class ListModelError implements Exception {
  final String message;
  const ListModelError(this.message);
}

class ItemUpdateError extends ListModelError {
  const ItemUpdateError({
    required Item item,
    required ListModel listModel,
  }) : super(
            'tried to update item "$item" in "$listModel", but operation failed. Database may be corrupted.');
}
