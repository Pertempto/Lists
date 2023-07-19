import 'dart:async' show Timer;

import 'package:clock/clock.dart';
import 'package:isar/isar.dart';
import 'package:lists/model/repeat_configuration.dart';
part 'item_scheduling.g.dart';

/// ItemScheduling:
///   - This class handles the scheduling and repeating of an `Item`
@embedded
class ItemScheduling {
  late DateTime scheduledTimeStamp;
  late RepeatConfiguration repeatConfiguration;
  @ignore
  Timer? scheduledTimer;

  ItemScheduling();
  ItemScheduling.fromRepeatConfiguration(this.repeatConfiguration)
      : scheduledTimeStamp = repeatConfiguration.nextRepeat;

  ItemScheduling copy() => ItemScheduling()
    ..scheduledTimeStamp = scheduledTimeStamp
    ..repeatConfiguration = repeatConfiguration.copy();

  void updateScheduledTimer({required void Function() timerCallback}) {
    cancelTimerIfScheduled();
    scheduledTimer = Timer(
      scheduledTimeStamp.difference(clock.now()),
      () {
        scheduledTimeStamp = repeatConfiguration.nextRepeat;
        timerCallback();
      },
    );
  }

  void cancelTimerIfScheduled() => scheduledTimer?.cancel();
}
