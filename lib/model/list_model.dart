import 'package:isar/isar.dart';
import 'package:lists/model/item.dart';

part 'list_model.g.dart';

/// ListModel:
///   - this class models a list in the app, such as a
///     to-do list, a shopping list, etc.
@Collection()
class ListModel {
  Id id = Isar.autoIncrement;
  late final String name;

  late List<Item> items;

  // a zero-arg constructor is required for classes that are isar collections
  ListModel();

  /// When isar loads a list model, the items list is fixed-length. This function
  /// makes it possible to add or remove items from this list model. Only necessary
  /// to call once.
  void makeItemsMutable() =>
    items = items.toList(growable: true);

  ListModel.make({required this.name}) : items = [];
}
