/// Item:
///   - objects of this class store a single item
///     in a list (needs to be wrapped in an ItemWidget
///     to be displayed)
class Item {
  String value;

  Item([this.value = 'New Item']);

  @override
  String toString() => value;
}
