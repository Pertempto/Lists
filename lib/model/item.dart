import 'package:isar/isar.dart';
import 'package:lists/model/item_scheduling.dart';
import 'package:lists/model/repeat_configuration.dart';
part 'item.g.dart';

/// Item:
///   - objects of this class store a single item
///     in a list (needs to be wrapped in an ItemWidget
///     to be displayed)
@Collection()
class Item {
  Id id = Isar.autoIncrement;
  late int order;

  late String value;
  @enumerated
  late ItemType itemType;

  bool isChecked = false;

  ItemScheduling? _scheduling;
  // _scheduling is wrapped in a getter and setter so that
  // it is never reassigned without first canceling its old timer 
  // (which would otherwise go off by the old scheduling, with 
  // no way to cancel it).
  ItemScheduling? get scheduling => _scheduling;
  set scheduling(ItemScheduling? newScheduling) {
    _scheduling?.cancelTimerIfScheduled();
    _scheduling = newScheduling;
  }

  @ignore
  bool get isScheduled => scheduling != null;

  Item([this.value = '', this.itemType = ItemType.checkbox, this._scheduling]);

  // This method is needed to update the fields of a cached `Item`
  // in the `IsarLinks` of a `ListModel` with the same `id` as `this`,
  // but out-of-date fields (see `ListModel.update()`)
  void copyOnto(Item item) {
    item.value = value;
    item.itemType = itemType;
    item.isChecked = isChecked;
    
    // Do a deep copy of the `scheduling` so that changing
    // the scheduling of `this` does not affect the scheduling
    // of `item` (or  vice-versa).
    item.scheduling = scheduling?.copy();
  }

  /// Needed for when an item is deleted.
  /// Cancels the `scheduledTimer` of `scheduling` (if there is one)
  /// so that its callback is not called on a deleted item (`this`).
  void dispose() => scheduling?.cancelTimerIfScheduled();

  void updateScheduledTimer({required void Function(Item) timerCallback}) =>
      scheduling?.updateScheduledTimer(timerCallback: () {
        isChecked = false;
        timerCallback(this);
      });
}

enum ItemType { text, checkbox }
