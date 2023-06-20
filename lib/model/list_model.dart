import 'package:collection/collection.dart';
import 'package:isar/isar.dart';
import 'package:lists/model/database_manager.dart';
import 'package:lists/model/item.dart';
import 'package:lists/model/list_model_item_group.dart';
import 'package:lists/model/item_group_search_results.dart';

part 'list_model.g.dart';

/// ListModel:
///   - this class models a list in the app, such as a
///     to-do list, a shopping list, etc.
@Collection()
class ListModel {
  Id id = Isar.autoIncrement;
  String title = '';

  final defaultItemGroupLink = IsarLink<ListModelItemGroup>();
  final itemGroups = IsarLinks<ListModelItemGroup>();

  @ignore
  ListModelItemGroup get defaultItemGroup => defaultItemGroupLink.value!;
  set defaultItemGroup(ListModelItemGroup itemGroup) =>
      defaultItemGroupLink.value = itemGroup;

  bool get hasDefaultItemGroup => defaultItemGroupLink.value != null;

  Iterable<ListModelItemGroup> groupsView() => [
        [defaultItemGroup],
        itemGroups
      ].flattened;

  @ignore
  int get itemCount => groupsView().fold(0,
      (runningItemCount, itemGroup) => runningItemCount + itemGroup.itemCount);
  ItemType get lastItemType {
    final lastItemGroup = itemGroups.lastOrNull ?? defaultItemGroup;
    final lastItems = lastItemGroup.items;

    return lastItems.lastOrNull?.itemType ?? ItemType.text;
  }

  // Iterable<Item> itemsView() => items;

  // a zero-arg constructor is required for classes that are isar collections
  ListModel();
  ListModel.fromTitle(this.title);

  void init() => reload();
  void reload() {
    defaultItemGroupLink.loadSync();
    itemGroups.loadSync();
    for (final itemGroup in groupsView()) {
      itemGroup.init();
    }
  }

  Future<void> ensureHasDefaultItemGroup() async {
    if (!hasDefaultItemGroup) {
      await DatabaseManager.putItemGroup(
          defaultItemGroup = ListModelItemGroup());
      await DatabaseManager.updateGroupsOfListModel(this);
    }
  }

  Future<void> addGroup(ListModelItemGroup itemGroup) async {
    await DatabaseManager.putItemGroup(itemGroup);
    itemGroups.add(itemGroup);
    await DatabaseManager.updateGroupsOfListModel(this);
  }

  Future<void> updateGroup(ListModelItemGroup itemGroup) async {
    assert(itemGroups.contains(itemGroup));
    await DatabaseManager.putItemGroup(itemGroup);
    await reloadGroup(itemGroup);
  }

  Future<void> reloadGroup(ListModelItemGroup itemGroup) async =>
      await lookupGroup(itemGroup).items.load();

  ListModelItemGroup lookupGroup(ListModelItemGroup itemGroup) =>
      itemGroup.id == defaultItemGroup.id
          ? defaultItemGroup
          : itemGroups.lookup(itemGroup)!;

  Future<void> addItem(Item newItem) async =>
      await (newItem.hasGroup ? lookupGroup(newItem.group) : defaultItemGroup)
          .add(newItem);

  Future<void> updateItem(Item item) async {
    if (await item.group.contains(item)) {
      await DatabaseManager.putItem(item);
      // The following ensures that the copy of `item` that `this` has is up to date.
      item.copyOnto(lookupItem(item));
    } else {
      throw ItemUpdateError(item: item, listModel: this);
    }
  }

  Item lookupItem(Item item) => lookupGroup(item.group).items.lookup(item)!;

  Future<void> removeItem(Item item) async =>
      await lookupGroup(item.group).remove(item);

  Future<void> moveItem(Item item, {required ListModelItemGroup to}) async {
    if (!item.hasGroup) item.group = to;

    final from = item.group;
    if (from.id == to.id) return;
    to.link(item);
    from.unlink(item);

    await DatabaseManager.updateGroupItems(from);
    await DatabaseManager.updateGroupItems(to);

    await reloadGroup(to);
    await reloadGroup(from);

    await item.groupLink.load();
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
    final parsedSearchQuery = _parseSearchQuery(searchQuery);
    final searchResults = <ItemGroupSearchResults>[];

    for (final itemGroup in groupsView()) {
      searchResults.add(await itemGroup.search(parsedSearchQuery));
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
