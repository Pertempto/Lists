import 'package:isar/isar.dart';
import 'item_group.dart';
import 'package:lists/model/item.dart';

part 'user_created_item_group.g.dart';

@Collection()
class UserCreatedItemGroup extends ItemGroup {
  Id id = Isar.autoIncrement;

  @ignore
  @override
  bool get hasTitle => true;
  @override
  late String title;

  @override
  final items = IsarLinks<Item>();

  // for isar
  UserCreatedItemGroup();
  UserCreatedItemGroup.fromTitle(this.title);

  @override
  Iterable<Item> itemsView() => items;

  @ignore
  @override
  int get itemCount => items.length;

  @override
  void init() => items.loadSync();
}
