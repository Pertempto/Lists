import 'package:isar/isar.dart';
import 'package:lists/model/database_manager.dart';
import 'package:lists/model/list_model_item_group.dart';
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
  final groupLink = IsarLink<ListModelItemGroup>();

  Item([this.value = '', this.itemType = ItemType.text]);

  @ignore
  bool get hasGroup => groupLink.value != null;
  @ignore
  ListModelItemGroup get group => groupLink.value!;
  set group(ListModelItemGroup newGroup) => groupLink.value = newGroup;
}

enum ItemType { text, checkbox }
