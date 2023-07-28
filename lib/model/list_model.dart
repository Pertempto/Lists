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

  @ignore
  Iterable<Item> get scheduledItems =>
      itemsView().where((item) => item.isScheduled);

  // a zero-arg constructor is required for classes that are isar collections
  ListModel();
  ListModel.fromTitle(this.title) : labels = [];

  void init() {
    items.loadSync();
    labels = labels.toList();
    updateTimersForScheduledItems();
  }

  void updateTimersForScheduledItems({void Function(Item)? timerCallback}) {
    for (final item in scheduledItems) {
      item.updateScheduledTimer(timerCallback: timerCallback ?? update);
    }
  }

  Future<void> add(Item newItem) async {
    await DatabaseManager.putItem(newItem);
    if (items.add(newItem)) {
      await DatabaseManager.updateListModelItems(this);
    }
  }

  Future<void> update(Item item,
      {void Function(Item)? scheduledTimerCallback}) async {
    if (items.contains(item)) {
      await DatabaseManager.putItem(item);

      final databaseItem = items.lookup(item)!;
      // The following ensures that the copy of `item` that `this` has is up to date.
      item.copyOnto(databaseItem);
      databaseItem.updateScheduledTimer(
          timerCallback: scheduledTimerCallback ?? update);
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

  /// To be called when `this` is deleted. See `Item.dispose`.
  void disposeItems() {
    for (final item in items) {
      item.dispose();
    }
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
