import 'dart:math';
import 'dart:async';

import 'package:collection/collection.dart';
import 'package:isar/isar.dart';
import 'package:lists/model/database_manager.dart';
import 'package:lists/model/item.dart';

part 'list_model.g.dart';

enum ListModelEvent { itemAdded, itemRemoved, itemUpdated }

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

  @ignore
  Iterable<Item> get scheduledItems =>
      itemsView().where((item) => item.isScheduled);

  @ignore
  Stream<ListModelEvent> get eventStream => _eventStreamController.stream;

  final _eventStreamController = StreamController<ListModelEvent>.broadcast();

  // a zero-arg constructor is required for classes that are isar collections
  ListModel();
  ListModel.fromTitle(this.title) : labels = [];

  void init() {
    items.loadSync();
    labels = labels.toList();
    for (final item in scheduledItems) {
      item.updateScheduledTimer(timerCallback: update);
    }
  }

  Future<void> add(Item newItem) async {
    newItem.order = itemCount;
    await DatabaseManager.putItem(newItem);
    if (items.add(newItem)) {
      await DatabaseManager.updateListModelItems(this);
      newItem.updateScheduledTimer(timerCallback: update);
      _eventStreamController.add(ListModelEvent.itemAdded);
    }
  }

  Future<void> update(Item item) async {
    if (items.contains(item)) {
      await DatabaseManager.putItem(item);

      final databaseItem = lookup(item);
      // The following ensures that the copy of `item` that `this` has is up to date.
      item.copyOnto(databaseItem);
      databaseItem.updateScheduledTimer(timerCallback: update);
      _eventStreamController.add(ListModelEvent.itemUpdated);
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
      _eventStreamController.add(ListModelEvent.itemRemoved);
    }
  }

  /// Gets the `Item` stored in `IsarLinks` with `item`'s id.
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

  bool hasLabel(String label) => labels.contains(label);

  /// To be called when `this` is deleted. See also `Item.dispose`.
  Future<void> dispose() async {
    for (final item in items) {
      item.dispose();
    }
    await _eventStreamController.close();
  }
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
