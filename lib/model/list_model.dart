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
  ItemGroup get defaultItemGroup => defaultItemGroupLink.value!;
  set defaultItemGroup(ItemGroup itemGroup) =>
      defaultItemGroupLink.value = itemGroup;

  bool get hasDefaultItemGroup => defaultItemGroupLink.value != null;

  Future<void> ensureHasDefaultItemGroup() async {
    if (!hasDefaultItemGroup) {
      await DatabaseManager.putItemGroup(defaultItemGroup = ItemGroup());
      DatabaseManager.updateListModelGroups(this);
    }
  }

  Future<void> addGroup(ItemGroup itemGroup) async {
    await DatabaseManager.putItemGroup(itemGroup);
    itemGroups.add(itemGroup);
    DatabaseManager.updateListModelGroups(this);
  }

  Iterable<Item> itemsView() =>
      groupsView().expand((itemGroup) => itemGroup.itemsView());

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

  Future<Iterable<ItemGroupSearchResults>> searchItems(
      String searchQuery) async {
    final words = _parseSearchStr(searchQuery);
    final searchResults = <ItemGroupSearchResults>[];

    for (final itemGroup in groupsView()) {
      searchResults.add(await itemGroup.searchItems(words));
    }

    return searchResults;
  }

  Iterable<String> _parseSearchStr(String searchQuery) => RegExp(r'([^\s]+)')
      .allMatches(searchQuery)
      .map((match) => match.group(0)!);
  // note: the above regex pattern "([^\s]+)" matches a string without spaces.
  // All-in-all, this function breaks a sentence apart into words (though
  // it doesn't filter out punctuation).
  // example:
  // "The  great,    blue sky!?!? #@  " --> ["The", "great,", "blue", "sky!?!?", "#@"]

  Future<void> add(Item newItem) async {
    await DatabaseManager.putItem(newItem);
    if (defaultItemGroup.add(newItem)) {
      await DatabaseManager.updateGroupItems(defaultItemGroup);
      await newItem.groupLink.load();
    }
  }

  Future<void> update(Item item) async {
    if (item.group.contains(item)) {
      await DatabaseManager.putItem(item);
      // await item.group.items.load();
      if (item.group.id == defaultItemGroup.id) {
        await defaultItemGroup.items.load();
      } else {
        await itemGroups.lookup(item.group)!.items.load();
        // TODO: fix remove. CLEAN SERIOUSLY!!!!!!!!
      }
    } else {
      throw ItemUpdateError(item: item, listModel: this);
    }
  }

  Future<void> remove(Item item) async {
    if (item.group.remove(item)) {
      await DatabaseManager.deleteItem(item);
      await DatabaseManager.updateGroupItems(item.group);
      if (item.group.id == defaultItemGroup.id) {
        await defaultItemGroup.items.load();
      } else {
        await itemGroups.lookup(item.group)!.items.load();
        // TODO: fix remove. CLEAN SERIOUSLY!!!!!!!!
      }
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
