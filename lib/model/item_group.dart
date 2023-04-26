import 'package:isar/isar.dart';
import 'package:lists/model/item.dart';

abstract class ItemGroup {
  bool get hasTitle;
  String? get title;

  Iterable<Item> itemsView();

  int get itemCount;

  void init();

  IsarLinks<Item> get items;

  Future<Iterable<Item>> searchItems(Iterable<String> searchWords) async =>
      await items
          .filter()
          .allOf(searchWords,
              (q, word) => q.valueContains(word, caseSensitive: false))
          .findAll();

  bool add(Item newItem) => items.add(newItem);
  bool contains(Item item) => items.contains(item);
  bool remove(Item item) => items.remove(item);
}
