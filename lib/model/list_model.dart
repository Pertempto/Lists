import 'package:collection/collection.dart';
import 'package:isar/isar.dart';
import 'package:lists/model/database_manager.dart';
import 'package:lists/model/item.dart';
import 'package:lists/model/item_group.dart';
import 'package:lists/model/item_group_search_results.dart';

part 'list_model.g.dart';

/// ListModel:
///   - this class models a list in the app, such as a
///     to-do list, a shopping list, etc.
@Collection()
class ListModel {
  Id id = Isar.autoIncrement;
  String title = '';

  final defaultItemGroupLink = IsarLink<ItemGroup>();
  final itemGroups = IsarLinks<ItemGroup>();

  @ignore
  ItemGroup get _defaultItemGroup => defaultItemGroupLink.value!;
  set _defaultItemGroup(ItemGroup newValue) =>
      defaultItemGroupLink.value = newValue;

  bool get hasDefaultItemGroup => defaultItemGroupLink.value != null;

  Future<void> createDefaultItemGroup() async {
    if (!hasDefaultItemGroup) {
      _defaultItemGroup = await DatabaseManager.putItemGroup(ItemGroup());
      DatabaseManager.updateListModelGroups(this);
    }
  }

  Iterable<Item> itemsView() =>
      groupsView().expand((itemGroup) => itemGroup.itemsView());

  Iterable<ItemGroup> groupsView() => <Iterable<ItemGroup>>[
        [_defaultItemGroup],
        itemGroups
      ].flattened;

  @ignore
  int get itemCount => itemGroups.fold(_defaultItemGroup.itemCount,
      (runningItemCount, itemGroup) => runningItemCount + itemGroup.itemCount);

  // a zero-arg constructor is required for classes that are isar collections
  ListModel();
  ListModel.fromTitle(this.title);

  void init() {
    defaultItemGroupLink.loadSync();
    itemGroups.loadSync();
    for (final itemGroup in groupsView()) {
      itemGroup.init();
    }
  }

  Future<Iterable<ItemGroupSearchResults>> searchItems(
      String searchQuery) async {
    final words = _parseSearchStr(searchQuery);
    final searchResults = <ItemGroupSearchResults>[];

    for (final itemGroup in groupsView()) {
      searchResults.add(await itemGroup.searchItems(words));
    }

    return searchResults;
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
    if (_defaultItemGroup.add(newItem)) {
      await DatabaseManager.updateGroupItems(_defaultItemGroup);
    }
  }

  Future<void> update(Item item) async {
    if (_defaultItemGroup.contains(item)) {
      await DatabaseManager.putItem(item);
    } else {
      throw ItemUpdateError(item: item, listModel: this);
    }
  }

  Future<void> remove(Item item) async {
    if (_defaultItemGroup.remove(item)) {
      await DatabaseManager.deleteItem(item);
      await DatabaseManager.updateGroupItems(_defaultItemGroup);
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
