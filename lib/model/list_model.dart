import 'package:isar/isar.dart';
import 'package:lists/model/item.dart';

part 'list_model.g.dart';

/// ListModel:
///   - this class models a list in the app, such as a
///     to-do list, a shopping list, etc.
@Collection()
class ListModel {
  Id id = Isar.autoIncrement;
  late String name;

  late List<Item> items;

  // a zero-arg constructor is required for classes that are isar collections
  ListModel();

  void ensureMutable() => items = items.toList(growable: true);

  ListModel.fromName(this.name) : items = [];
}
