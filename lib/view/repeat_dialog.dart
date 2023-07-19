import 'package:flutter/material.dart';
import 'package:lists/model/repeat_configuration.dart';
import 'package:weekday_selector/weekday_selector.dart';

class RepeatDialog extends StatefulWidget {
  final void Function(RepeatConfiguration) onSubmit;
  final RepeatConfiguration? repeatConfig;

  const RepeatDialog(
      {required this.onSubmit, required this.repeatConfig, super.key});

  @override
  State<RepeatDialog> createState() => _RepeatDialogState();
}

class _RepeatDialogState extends State<RepeatDialog> {
  late RepeatConfiguration selectedRepeatConfig =
      widget.repeatConfig?.copy() ?? RepeatConfiguration.fromNow();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Repeats', style: Theme.of(context).textTheme.titleLarge),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWeekdaySelector(),
          const SizedBox(height: 24),
          Row(
            children: [
              const Text('Time'),
              const SizedBox(width: 12),
              ActionChip(
                label: Text(TimeOfDay(
                        hour: selectedRepeatConfig.hour,
                        minute: selectedRepeatConfig.minute)
                    .format(context)),
                onPressed: () async {
                  final newTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay(
                          hour: selectedRepeatConfig.hour,
                          minute: selectedRepeatConfig.minute));
                  if (newTime != null) {
                    setState(() {
                      selectedRepeatConfig.hour = newTime.hour;
                      selectedRepeatConfig.minute = newTime.minute;
                    });
                  }
                },
              )
            ],
          )
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            widget.onSubmit(selectedRepeatConfig);
          },
          child: const Text('Submit'),
        )
      ],
    );
  }

  Widget _buildWeekdaySelector() {
    // Note:
    // The weekday selector takes a `List<bool?>` (values) with a length of 7.
    // Each index corresponds to a day, where index 0 corresponds to Sunday, 
    // index 1 to Monday, and index 6 to Saturday. This is slightly different from 
    // how `DateTime` does things, where Sunday equals 7 and everything else is the same. So,
    // a weekday stored in `selectedRepeatConfig.weekdays` needs to be modulated by 7
    // before being used as an index into `values`.
    final values = List.filled(7, false);
    for (final weekday in selectedRepeatConfig.weekdays) {
      values[weekday % 7] = true;
    }

    return SizedBox(
            width: 280,
            child: WeekdaySelector(
                firstDayOfWeek: DateTime.sunday,
                onChanged: (int weekday) => setState(() {
                      if (values[weekday % 7]) {
                        // If there is only one weekday selected we don't unselect it, because 
                        // having a `RepeatConfiguration` with an empty weekdays field
                        // is not implemented.
                        if (selectedRepeatConfig.weekdays.length - 1 > 0) {
                          selectedRepeatConfig.weekdays.remove(weekday);
                        }
                      } else {
                        selectedRepeatConfig.weekdays.add(weekday);
                      }
                    }),
                values: values));
  }
}
