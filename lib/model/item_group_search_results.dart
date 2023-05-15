import 'package:isar/isar.dart';
import 'package:lists/model/item.dart';
import 'package:lists/model/item_group.dart';
import 'package:lists/model/item_group_base.dart';

class ItemGroupSearchResults extends ItemGroupBase {
  final ItemGroupBase _group;
  final Iterable<Item> _results;

  @override
  String? get title => group.title;
  @override
  set title(String? newTitle) => group.title = newTitle;

  const ItemGroupSearchResults(
      {required ItemGroupBase group, required Iterable<Item> results})
      : _group = group,
        _results = results;

  @override
  int get itemCount => _results.length;

  @override
  Iterable<Item> itemsView() => _results;

  ItemGroupBase get group => _group;

  @override
  Future<ItemGroup> asDatabaseItemGroup() => _group.asDatabaseItemGroup();
}
