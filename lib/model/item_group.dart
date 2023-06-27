import 'package:isar/isar.dart';
import 'package:lists/model/database_manager.dart';
import 'package:lists/model/item.dart';
import 'package:lists/model/abstract_item_group.dart';
import 'package:lists/model/filtered_item_group.dart';

part 'item_group.g.dart';

/// ItemGroup:
///   - This is a normal item group, stored in a `ListModel`
// note: inheritance is false so that isar ignores the `AbstractItemGroup.originalGroup` property.
@Collection(inheritance: false)
class ItemGroup extends AbstractItemGroup {
  Id id = Isar.autoIncrement;

  @override
  String? title;
  final items = IsarLinks<Item>();

  ItemGroup({this.title});

  @ignore
  @override
  int get itemCount => items.length;

  @override
  Iterable<Item> itemsView() => items;

  @ignore
  @override
  ItemGroup get originalGroup => this;

  void init() => items.loadSync();

  Future<void> add(Item newItem) async {
    await DatabaseManager.putItem(newItem);
    link(newItem);

    await DatabaseManager.updateGroupItems(this);
    await newItem.groupLink.load();
  }

  Future<bool> contains(Item item) async => items.contains(item);

  Future<void> remove(Item item) async {
    unlink(item);
    await DatabaseManager.deleteItem(item);
    await DatabaseManager.updateGroupItems(item.group);
  }

  Future<FilteredItemGroup> search(Iterable<String> searchWords) async =>
      FilteredItemGroup(
          group: this,
          results: await items
              .filter()
              .allOf(searchWords,
                  (q, word) => q.valueContains(word, caseSensitive: false))
              .findAll());

  void link(Item item) {
    assert(items.add(item));
  }

  void unlink(Item item) {
    assert(items.remove(item));
  }
}
