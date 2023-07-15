import 'dart:async' show Timer;
import 'package:clock/clock.dart';
import 'package:isar/isar.dart';
import 'package:lists/model/repeat_configuration.dart';
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

  RepeatConfiguration? repeatConfiguration;
  DateTime? scheduledTimeStamp;
  @ignore
  Timer? scheduledTimer;

  @ignore
  bool get isRepeating => repeatConfiguration != null;

  Item(
      [this.value = '',
      this.itemType = ItemType.text,
      this.repeatConfiguration]);

  // This method is needed to update the fields of a cached `Item`
  // in the `IsarLinks` of a `ListModel` with the same `id` as `this`,
  // but out-of-date fields (see `ListModel.update()`)
  void copyOnto(Item item) {
    item.value = value;
    item.itemType = itemType;
    item.isChecked = isChecked;
    // Do a deep copy of the repeat configuration so that changing
    // the repeat config of `this` does not affect the repeat config
    // of `item` (or  vice-versa).
    item.repeatConfiguration = repeatConfiguration?.copy();
    item.scheduledTimeStamp = scheduledTimeStamp;

    item.scheduledTimer?.cancel();
    item.scheduledTimer = scheduledTimer;
  }

  void resetScheduledTimer({required void Function(Item) callback}) {
    scheduledTimer?.cancel();
    scheduledTimer = Timer(
      scheduledTimeStamp!.difference(clock.now()),
      () {
        isChecked = false;
        scheduledTimeStamp = repeatConfiguration!.nextRepeat;
        callback(this);
      },
    );
  }

  /// Needed for when an item is deleted.
  /// Cancels the `scheduledTimer` (if there is one) so that
  /// its callback is not called on a deleted item (`this`).
  void dispose() => scheduledTimer?.cancel();
}

enum ItemType { text, checkbox }
