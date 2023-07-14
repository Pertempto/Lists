import 'package:clock/clock.dart';
import 'package:collection/collection.dart';
import 'package:isar/isar.dart';
part 'repeat_configuration.g.dart';

@embedded
class RepeatConfiguration {
  late List<int> days;
  int hour = 0;
  int minute = 0;

  // We need a default constructor for isar.
  RepeatConfiguration();

  RepeatConfiguration.weekly({required this.days, this.hour = 0, this.minute = 0});

  factory RepeatConfiguration.fromNow() =>
      RepeatConfiguration.weekly(days: [clock.now().weekday]);

  RepeatConfiguration copy() =>
      RepeatConfiguration.weekly(days: days.toList(), hour: hour, minute: minute);

// TODO: clean
  DateTime get nextRepeat {
    final now = clock.now();
    final adjustedNow =
        (now.difference(now.copyWith(hour: hour, minute: minute)).isNegative)
            ? now
            : now.add(const Duration(days: 1));

    return adjustedNow
        .add(Duration(
            days: (minBy(
                        days.map((day) => [
                              day,
                              (day - adjustedNow.weekday) % DateTime.daysPerWeek
                            ]),
                        (value) => value[1])![0] -
                    adjustedNow.weekday) %
                DateTime.daysPerWeek))
        .copyWith(
            hour: hour,
            minute: minute,
            second: 0,
            millisecond: 0,
            microsecond: 0);
  }
}
