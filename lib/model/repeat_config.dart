import 'package:collection/collection.dart';
import 'package:isar/isar.dart';
part 'repeat_config.g.dart';

/// RepeatConfig:
///   - This class contains the information used by `ItemScheduling` to 
///     schedule/reschedule a repeating item.
@embedded
class RepeatConfig {
  late List<int> weekdays;
  int hour = 0;
  int minute = 0;

  // We need a default constructor for isar.
  RepeatConfig();

  RepeatConfig.weekly(
      {required this.weekdays, this.hour = 0, this.minute = 0});

  factory RepeatConfig.fromNow() =>
      RepeatConfig.weekly(weekdays: [DateTime.now().weekday]);

  /// Used by `Item.copyOnto()`. Returns a deep copy of `this`.
  RepeatConfig copy() => RepeatConfig.weekly(
      weekdays: weekdays.toList(), hour: hour, minute: minute);

  DateTime get nextRepeat {
    final now = DateTime.now();
    final nowWithConfiguredTime = now.copyWith(
        hour: hour, minute: minute, second: 0, millisecond: 0, microsecond: 0);

    final closestPossibleNextRepeat = now.isBefore(nowWithConfiguredTime)
        ? nowWithConfiguredTime
        : nowWithConfiguredTime.add(const Duration(days: 1));

    final closestWeekday =
        _calculateClosestWeekday(closestPossibleNextRepeat.weekday);

    return closestPossibleNextRepeat.add(Duration(
        days: _daysToGetToWeekday(
            from: closestPossibleNextRepeat.weekday, to: closestWeekday)));
  }

  int _calculateClosestWeekday(int closestPossibleWeekday) => minBy(
      weekdays,
      (weekday) =>
          _daysToGetToWeekday(from: closestPossibleWeekday, to: weekday))!;

  // Returns the number of days to wait from the weekday `from`
  // to get to the weekday `to`.
  int _daysToGetToWeekday({required int from, required int to}) =>
      (to - from) % 7;
}
