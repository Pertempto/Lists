import 'package:isar/isar.dart';
import 'package:lists/model/item_group.dart';
import 'package:lists/model/item.dart';

class DefaultItemGroup extends ItemGroup {
  @ignore
  @override
  bool get hasTitle => false;
  @ignore
  @override
  String? get title => null;

  @override
  final items = IsarLinks<Item>();

  @override
  Iterable<Item> itemsView() => items;

  @ignore
  @override
  int get itemCount => items.length;

  @override
  void init() => items.loadSync();
}
