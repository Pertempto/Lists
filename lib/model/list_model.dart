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
  ItemType get lastItemType => items.lastOrNull?.itemType ?? ItemType.checkbox;

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
    // Use an order value larger than the largest order value.
    newItem.order = (maxBy(items, (item) => item.order)?.order ?? -1) + 1;
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
      await DatabaseManager.deleteItem(item);
      await DatabaseManager.updateListModelItems(this);
      _eventStreamController.add(ListModelEvent.itemRemoved);
    }
  }

  /// Gets the `Item` stored in `IsarLinks` with `item`'s id.
  Item lookup(Item item) => items.lookup(item)!;

  Future<void> reorderItems(List<Item> items) async =>
      DatabaseManager.putItems(items);

  Future<Iterable<Item>> searchItems(String searchQuery) {
    final words = Isar.splitWords(searchQuery);
    return items
        .filter()
        .allOf(words, (q, word) => q.valueContains(word, caseSensitive: false))
        .findAll();
  }

  bool hasLabel(String label) => labels.contains(label);

  /// To be called when `this` is deleted. See also `Item.dispose`.
  Future<void> dispose() async {
    for (final item in items) {
      item.dispose();
    }
    await _eventStreamController.close();
  }

  String asMarkdown({required bool includeLabels}) {
    var ret = '## $title\n';
    if (includeLabels) ret += '${labels.map((label) => '#label').join(' ')}\n';

    return ret +
        items.sorted((a, b) => a.order - b.order).map((item) {
          final leading = (item.itemType == ItemType.checkbox
              ? '- [${item.isChecked ? 'x' : ' '}]'
              : '-');
          return '$leading ${item.value}';
        }).join('\n');
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
