import 'dart:async' show Timer;

import 'package:isar/isar.dart';
import 'package:lists/model/repeat_configuration.dart';
part 'item_scheduling.g.dart';

/// ItemScheduling:
///   - This class handles the scheduling and repeating of an `Item`
@embedded
class ItemScheduling {
  late DateTime scheduledTimeStamp;
  late RepeatConfig repeatConfig;
  @ignore
  Timer? scheduledTimer;

  ItemScheduling();
  ItemScheduling.fromRepeatConfig(this.repeatConfig)
      : scheduledTimeStamp = repeatConfig.nextRepeat;

  ItemScheduling copy() => ItemScheduling()
    ..scheduledTimeStamp = scheduledTimeStamp
    ..repeatConfig = repeatConfig.copy();

  void updateScheduledTimer({required void Function() timerCallback}) {
    cancelTimerIfScheduled();
    scheduledTimer = Timer(
      scheduledTimeStamp.difference(DateTime.now()),
      () {
        scheduledTimeStamp = repeatConfig.nextRepeat;
        timerCallback();
      },
    );
  }

  void cancelTimerIfScheduled() => scheduledTimer?.cancel();
}
