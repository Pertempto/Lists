import 'package:isar/isar.dart';
import 'package:lists/model/database_manager.dart';
import 'package:lists/model/item.dart';
import 'package:lists/model/item_group.dart';
import 'package:lists/model/item_group_search_results.dart';

part 'list_model_item_group.g.dart';

/// ListModelItemGroup:
///   - an `ItemGroup` that is contained within a `ListModel`
@Collection()
class ListModelItemGroup extends ItemGroup {
  Id id = Isar.autoIncrement;

  @override
  String? title;
  final items = IsarLinks<Item>();

  ListModelItemGroup({this.title});

  @ignore
  @override
  int get itemCount => items.length;

  @override
  Iterable<Item> itemsView() => items;

  @override
  Future<ListModelItemGroup> asListModelItemGroup() async => this;

  void init() => items.loadSync();

  Future<void> add(Item newItem) async {
    await DatabaseManager.putItem(newItem);
    assert(items.add(newItem));

    await DatabaseManager.updateGroupItems(this);
    await newItem.groupLink.load();
  }

  Future<bool> contains(Item item) async => items.contains(item);

  Future<void> remove(Item item) async {
    assert(items.remove(item));
    await DatabaseManager.deleteItem(item);
    await DatabaseManager.updateGroupItems(item.group);
  }

  Future<ItemGroupSearchResults> search(Iterable<String> searchWords) async =>
      ItemGroupSearchResults(
          group: this,
          results: await items
              .filter()
              .allOf(searchWords,
                  (q, word) => q.valueContains(word, caseSensitive: false))
              .findAll());
}
