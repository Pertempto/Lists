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
    await DatabaseManager.putItem(newItem);
    if (items.add(newItem)) {
      await DatabaseManager.updateListModelItems(this);
    }
  }

  Future<void> update(Item item) async {
    if (items.contains(item)) {
      await DatabaseManager.putItem(item);
      // The following ensures that the copy of `item` that `this` has is up to date.
      item.copyOnto(items.lookup(item)!);
    } else {
      throw ItemUpdateError(item: item, listModel: this);
    }
  }

  Future<void> remove(Item item) async {
    if (items.remove(item)) {
      await DatabaseManager.deleteItem(item);
      await DatabaseManager.updateListModelItems(this);
    }
  }

  void moveItem({required int from, required int to}) {
    assert(from < items.length && from >= 0);
    assert(to <= items.length && to >= 0);

    if (to > from) {
      _moveItemUp(from: from, to: to);
    } else if (to < from) {
      _moveItemDown(from: from, to: to);
    }
  }

  void _moveItemUp({required int from, required int to}) {
    final startIndexOfItemsToBeRotated = from;
    final endIndexOfItemsToBeRotated = to;
    final itemsToBeRotated = _sliceItems(
        start: startIndexOfItemsToBeRotated, end: endIndexOfItemsToBeRotated);

    _rotateItemsLeft(items: itemsToBeRotated);
    DatabaseManager.putItems(itemsToBeRotated);
  }

  void _moveItemDown({required int from, required int to}) {
    final startIndexOfItemsToBeRotated = to;
    final endIndexOfItemsToBeRotated = from+1;
    final itemsToBeRotated = _sliceItems(
        start: startIndexOfItemsToBeRotated, end: endIndexOfItemsToBeRotated);

    _rotateItemsLeft(items: itemsToBeRotated.reversed);
    DatabaseManager.putItems(itemsToBeRotated);
  }

  /// returns a list containing the items with indexes in the range [start, end)
  List<Item> _sliceItems({required int start, required int end}) {
    final numberOfSlicedItems = end - start;
    return items.skip(start).take(numberOfSlicedItems).toList();
  }

  static void _rotateItemsLeft({required Iterable<Item> items}) {
    final movedItemCopy = Item();
    var prev = movedItemCopy;

    for (final item in items) {
      item.copyOnto(prev);
      prev = item;
    }

    movedItemCopy.copyOnto(items.last);
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
