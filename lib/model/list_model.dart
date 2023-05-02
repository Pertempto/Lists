import 'package:collection/collection.dart';
import 'package:isar/isar.dart';
import 'package:lists/model/database_manager.dart';
import 'package:lists/model/item.dart';
import 'package:lists/model/default_item_group.dart';
import 'package:lists/model/item_group.dart';
import 'package:lists/model/user_created_item_group.dart';

part 'list_model.g.dart';

/// ListModel:
///   - this class models a list in the app, such as a
///     to-do list, a shopping list, etc.
@Collection()
class ListModel {
  Id id = Isar.autoIncrement;
  String title = '';

  @ignore
  final DefaultItemGroup defaultItemGroup = DefaultItemGroup();
  final userCreatedItemGroups = IsarLinks<UserCreatedItemGroup>();

  // note: for isar
  IsarLinks<Item> get defaultItemGroupItems => defaultItemGroup.items;

  Iterable<Item> itemsView() =>
      groupsView().expand((itemGroup) => itemGroup.itemsView());

  Iterable<ItemGroup> groupsView() => <Iterable<ItemGroup>>[
        [defaultItemGroup],
        userCreatedItemGroups
      ].flattened;

  @ignore
  int get itemCount => userCreatedItemGroups.fold(defaultItemGroup.itemCount,
      (runningItemCount, itemGroup) => runningItemCount + itemGroup.itemCount);

  // a zero-arg constructor is required for classes that are isar collections
  ListModel();
  ListModel.fromTitle(this.title);

  void init() {
    userCreatedItemGroups.loadSync();
    for (final itemGroup in groupsView()) {
      itemGroup.init();
    }
  }

  Future<Iterable<Item>> searchItems(String searchQuery) async {
    final words = _parseSearchStr(searchQuery);
    final searchResults = <Iterable<Item>>[];

    for (final itemGroup in groupsView()) {
      searchResults.add(await itemGroup.searchItems(words));
    }

    return searchResults.flattened;
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
    if (defaultItemGroup.add(newItem)) {
      await DatabaseManager.updateGroupItems(defaultItemGroup);
    }
  }

  Future<void> update(Item item) async {
    if (defaultItemGroup.contains(item)) {
      await DatabaseManager.putItem(item);
    } else {
      throw ItemUpdateError(item: item, listModel: this);
    }
  }

  Future<void> remove(Item item) async {
    if (defaultItemGroup.remove(item)) {
      await DatabaseManager.deleteItem(item);
      await DatabaseManager.updateGroupItems(defaultItemGroup);
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
