import 'package:isar/isar.dart';
import 'package:lists/model/database_manager.dart';
import 'package:lists/model/item_group.dart';
import 'package:lists/model/list_model.dart';

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

  @Backlink(to: "items")
  final groupLink = IsarLink<ItemGroup>();

  Item([this.value = '', this.itemType = ItemType.text]);

  @ignore
  bool get hasGroup => groupLink.value != null;
  @ignore
  ItemGroup get group => groupLink.value!;
  set group(ItemGroup newGroup) => groupLink.value = newGroup;
  // This method is needed to update the fields of a cached `Item`
  // in the `IsarLinks` of a `ListModel` with the same `id` as `this`,
  // but out-of-date fields (see `ListModel.update()`)
  void copyOnto(Item item) {
    item.value = value;
    item.itemType = itemType;
    item.isChecked = isChecked;
  }
}

enum ItemType { text, checkbox }
