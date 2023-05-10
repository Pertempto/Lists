import 'package:lists/model/item.dart';
import 'package:lists/model/item_group.dart';
import 'package:lists/model/item_group_base.dart';

class ItemGroupSearchResults extends ItemGroupBase {
  final ItemGroup _group;
  final Iterable<Item> _results;

  @override
  String? get title => group.title;

  const ItemGroupSearchResults(
      {required ItemGroup group, required Iterable<Item> results})
      : _group = group,
        _results = results;

  @override
  int get itemCount => _results.length;

  @override
  Iterable<Item> itemsView() => _results;

  ItemGroup get group => _group;
  Iterator<Item> get iterator => _results.iterator;

  @override
  String toString() =>
      'ItemGroupSearchResults(itemCount: $itemCount, itemsView: ${itemsView()}, group: $group)';
}
