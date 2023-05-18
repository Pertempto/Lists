import 'package:lists/model/item.dart';
import 'package:lists/model/list_model_item_group.dart';
import 'package:lists/model/item_group.dart';

/// ItemGroupSearchResults:
///   - an `ItemGroup` that contains the results of searching in another `ItemGroup`
class ItemGroupSearchResults extends ItemGroup {
  final ItemGroup _group;
  final Iterable<Item> _results;

  @override
  String? get title => _group.title;
  @override
  set title(String? newTitle) => _group.title = newTitle;

  const ItemGroupSearchResults(
      {required ItemGroup group, required Iterable<Item> results})
      : _group = group,
        _results = results;

  @override
  int get itemCount => _results.length;

  @override
  Iterable<Item> itemsView() => _results;

  @override
  Future<ListModelItemGroup> asListModelItemGroup() =>
      _group.asListModelItemGroup();
}
