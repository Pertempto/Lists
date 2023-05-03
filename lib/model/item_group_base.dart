import 'package:lists/model/item.dart';

abstract class ItemGroupBase {
  String? get title;
  Iterable<Item> itemsView();
  int get itemCount;

  const ItemGroupBase();
}
