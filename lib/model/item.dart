import 'package:isar/isar.dart';
part 'item.g.dart';

/// Item:
///   - objects of this class store a single item
///     in a list (needs to be wrapped in an ItemWidget
///     to be displayed)
@Collection()
class Item {
  Id id = Isar.autoIncrement;
  late String value;
  @enumerated
  late ItemType itemType;

  bool isChecked = false;

  Item([this.value = '', this.itemType = ItemType.text]);

  void copyOnto(Item item) {
    item.value = value;
    item.itemType = itemType;
    item.isChecked = isChecked;
  }
}

enum ItemType { text, checkbox }
