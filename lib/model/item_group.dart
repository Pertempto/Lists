import 'package:isar/isar.dart';
import 'package:lists/model/item.dart';
import 'package:lists/model/item_group_base.dart';
import 'package:lists/model/item_group_search_results.dart';

part 'item_group.g.dart';

@Collection()
class ItemGroup extends ItemGroupBase {
  Id id = Isar.autoIncrement;
  @override
  String? title;
  final items = IsarLinks<Item>();

  ItemGroup({this.title});

  @override
  int get itemCount => items.length;

  @override
  Iterable<Item> itemsView() => items;

  void init() {
    items.loadSync();
    for (final item in items) {
      item.init();
    }
  }

  Future<ItemGroupSearchResults> searchItems(
          Iterable<String> searchWords) async =>
      ItemGroupSearchResults(
          group: this,
          results: await items
              .filter()
              .allOf(searchWords,
                  (q, word) => q.valueContains(word, caseSensitive: false))
              .findAll());

  bool add(Item newItem) => items.add(newItem);
  bool contains(Item item) => items.contains(item);
  bool remove(Item item) => items.remove(item);
}
