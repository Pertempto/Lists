import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:lists/model/item.dart';
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
    final values = List.filled(7, false);
    for (final weekday in selectedRepeatConfig.days) {
      values[weekday % 7] = true;
    }

    return AlertDialog(
      title: Text('Repeats', style: Theme.of(context).textTheme.titleLarge),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              width: 280,
              child: WeekdaySelector(
                  firstDayOfWeek: DateTime.sunday,
                  onChanged: (int weekday) => setState(() {
                        if (values[weekday % 7]) {
                          if (selectedRepeatConfig.days.length - 1 > 0)
                            selectedRepeatConfig.days.remove(weekday);
                        } else {
                          selectedRepeatConfig.days.add(weekday);
                        }
                      }),
                  values: values)),
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
}
