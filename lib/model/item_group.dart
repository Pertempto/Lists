import 'package:lists/model/item.dart';
import 'package:lists/model/list_model_item_group.dart';

/// ItemGroup:
///   - an abstract base class for a group of items with a title.
abstract class ItemGroup {
  String? get title;
  set title(String? newTitle);

  Iterable<Item> itemsView();
  int get itemCount;

  const ItemGroup();

  Future<ListModelItemGroup> asListModelItemGroup();
}
