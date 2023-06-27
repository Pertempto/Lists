import 'package:lists/model/item.dart';
import 'package:lists/model/item_group.dart';
import 'package:lists/model/abstract_item_group.dart';

/// FilteredItemGroup:
///   - This is an item group that has had a filter applied to it.
class FilteredItemGroup extends AbstractItemGroup {
  final ItemGroup _group;
  final Iterable<Item> _results;

  @override
  String? get title => _group.title;
  @override
  set title(String? newTitle) => _group.title = newTitle;

  const FilteredItemGroup(
      {required ItemGroup group, required Iterable<Item> results})
      : _group = group,
        _results = results;

  @override
  int get itemCount => _results.length;

  @override
  Iterable<Item> itemsView() => _results;

  @override
  ItemGroup get originalGroup => _group;
}
