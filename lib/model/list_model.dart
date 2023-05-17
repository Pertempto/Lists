import 'package:collection/collection.dart';
import 'package:isar/isar.dart';
import 'package:lists/model/database_manager.dart';
import 'package:lists/model/item.dart';
import 'package:lists/model/item_group.dart';
import 'package:lists/model/item_group_base.dart';
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
  ItemGroup get defaultItemGroup => defaultItemGroupLink.value!;
  set defaultItemGroup(ItemGroup itemGroup) =>
      defaultItemGroupLink.value = itemGroup;

  bool get hasDefaultItemGroup => defaultItemGroupLink.value != null;

  Iterable<ItemGroup> groupsView() => [
        [defaultItemGroup],
        itemGroups
      ].flattened;

  @ignore
  int get itemCount => groupsView().fold(0,
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

  Future<void> ensureHasDefaultItemGroup() async {
    if (!hasDefaultItemGroup) {
      await DatabaseManager.putItemGroup(defaultItemGroup = ItemGroup());
      await DatabaseManager.updateListModelGroups(this);
    }
  }

  Future<void> addGroup(ItemGroup itemGroup) async {
    await DatabaseManager.putItemGroup(itemGroup);
    itemGroups.add(itemGroup);
    await DatabaseManager.updateListModelGroups(this);
  }

  Future<void> updateGroup(ItemGroup itemGroup) async {
    assert(itemGroups.contains(itemGroup));
    await DatabaseManager.putItemGroup(itemGroup);
    await reloadGroup(itemGroup);
  }

  Future<void> add(Item newItem) async =>
      await (newItem.hasGroup ? lookupGroup(newItem.group) : defaultItemGroup)
          .add(newItem);

  Future<void> update(Item item) async {
    if (await item.group.contains(item)) {
      await DatabaseManager.putItem(item);
    } else {
      throw ItemUpdateError(item: item, listModel: this);
    }
  }

  Future<void> remove(Item item) async {
    await item.group.remove(item);
    await reloadGroup(item.group);
  }

  Future<void> reloadGroup(ItemGroup itemGroup) async {
    await lookupGroup(itemGroup).items.load();
  }

  ItemGroup lookupGroup(ItemGroup itemGroup) {
    if (itemGroup.id == defaultItemGroup.id) {
      return defaultItemGroup;
    } else {
      return itemGroups.lookup(itemGroup)!;
    }
  }

  Iterable<String> _parseSearchQuery(String searchQuery) => RegExp(r'([^\s]+)')
      .allMatches(searchQuery)
      .map((match) => match.group(0)!);
  // note: the above regex pattern "([^\s]+)" matches a string without spaces.
  // All-in-all, this function breaks a sentence apart into words (though
  // it doesn't filter out punctuation).
  // example:
  // "The  great,    blue sky!?!? #@  " --> ["The", "great,", "blue", "sky!?!?", "#@"]

  Future<Iterable<ItemGroupSearchResults>> searchItems(
      String searchQuery) async {
    final searchStr = _parseSearchQuery(searchQuery);
    final searchResults = <ItemGroupSearchResults>[];

    for (final itemGroup in groupsView()) {
      searchResults.add(await itemGroup.search(searchStr));
    }
    return searchResults;
  }
}

class ListModelError implements Exception {
  final String message;
  const ListModelError(this.message);
}

class ItemUpdateError extends ListModelError {
  ItemUpdateError({
    required Item item,
    required ListModel listModel,
  }) : super(
            'tried to update item "$item" in group "${item.group}" in list "$listModel", but operation failed. Database may be corrupted.');
}
