import 'package:flutter/material.dart';
import 'package:lists/common/time_stamp_format.dart';
import 'package:lists/model/item.dart';
import 'package:lists/model/item_scheduling.dart';
import 'package:lists/view/edit_item_dialog.dart';
import 'package:lists/view/repeat_dialog.dart';

/// ItemWidget:
///   - a widget representing the view of a single item
///     in a list (see Item)
class ItemWidget extends StatefulWidget {
  final Item item;
  final bool tappable;
  final void Function() onDelete;
  final void Function() onEdited;

  const ItemWidget(this.item,
      {this.tappable = true,
      required this.onDelete,
      required this.onEdited,
      super.key});

  @override
  State<ItemWidget> createState() => _ItemWidgetState();
}

class _ItemWidgetState extends State<ItemWidget> {
  @override
  Widget build(BuildContext context) {
    final itemTextStyle =
        Theme.of(context).textTheme.titleLarge ?? const TextStyle();

    Widget? checkbox;
    TextDecoration? textDecoration;

    if (widget.item.itemType == ItemType.checkbox) {
      checkbox = Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Checkbox(
            value: widget.item.isChecked,
            onChanged: _onNewCheckedState,
            visualDensity: const VisualDensity(
                horizontal: VisualDensity.maximumDensity,
                vertical: VisualDensity.maximumDensity),
          ));

      textDecoration =
          widget.item.isChecked ? TextDecoration.lineThrough : null;
    }

    return InkWell(
        onTap: widget.tappable ? _showEditDialog : null,
        child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (checkbox != null) checkbox,
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.item.value,
                            style: itemTextStyle.copyWith(
                                decoration: textDecoration)),
                        if (widget.item.isScheduled)
                          _buildScheduledTimeStampChip()
                      ]),
                )
              ],
            )));
  }

  void _onNewCheckedState(bool? value) {
    widget.item.isChecked = value!;
    updateThis();
  }

  Widget _buildScheduledTimeStampChip() => Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: ActionChip(
            avatar:
                Icon(Icons.repeat, color: Theme.of(context).iconTheme.color),
            label: Text(timeStampFormat
                .format(widget.item.scheduling!.scheduledTimeStamp)),
            onPressed: () => showDialog(
                context: context,
                builder: (context) => RepeatDialog(
                    onSubmit: (newRepeatConfig) async {
                      widget.item.scheduling =
                          ItemScheduling.fromRepeatConfiguration(
                              newRepeatConfig);
                      updateThis();
                    },
                    repeatConfig: widget.item.scheduling?.repeatConfiguration)),
          ),
        ),
      );

  void _showEditDialog() => showDialog(
      context: context,
      builder: (context) => EditItemDialog(
          onSubmit: (_) => updateThis(),
          onDelete: widget.onDelete,
          item: widget.item));

  void updateThis() {
    widget.onEdited();
  }
}
