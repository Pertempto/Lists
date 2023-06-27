import 'package:lists/model/item.dart';
import 'package:lists/model/item_group.dart';

/// AbstractItemGroup:
///   This defines the basic interface for an item group
abstract class AbstractItemGroup {
  String? get title;
  set title(String? newTitle);

  Iterable<Item> itemsView();
  int get itemCount;

  const AbstractItemGroup();

  ItemGroup get originalGroup;
}
