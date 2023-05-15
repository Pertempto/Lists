import 'package:isar/isar.dart';
import 'package:lists/model/item.dart';
import 'package:lists/model/item_group.dart';

abstract class ItemGroupBase {
  String? get title;
  set title(String? newTitle);

  Iterable<Item> itemsView();
  int get itemCount;

  const ItemGroupBase();

  Future<ItemGroup> asDatabaseItemGroup();
}
