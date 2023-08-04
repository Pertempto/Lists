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

  void moveItem({required int from, required int to}) {
    assert(from < items.length && from >= 0);
    assert(to <= items.length && to >= 0);

    final bounds = [from, to].sorted((a, b) => a - b);
    int lower = bounds[0] == from ? bounds[0] + 1 : bounds[0];
    int upper = bounds[1] - 1;
    final itemsToRotate = items
        .filter()
        .orderBetween(lower, upper)
        .findAllSync()
        .map((item) => lookup(item));
    final itemFrom =
        lookup(items.filter().orderEqualTo(from).findAllSync().single);

    itemsToRotate.forEach((item) => item.order += ((from - to).sign));
    itemFrom.order = from < to ? to - 1 : to;
    DatabaseManager.putItems([...itemsToRotate, itemFrom]);
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
