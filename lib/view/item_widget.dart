import 'package:flutter/material.dart';
import 'package:lists/model/item.dart';
import 'package:lists/view/edit_item_dialog.dart';
import 'package:lists/view/editing_actions_modal_bottom_sheet.dart';

/// ItemWidget:
///   - a widget representing the view of a single item
///     in a list (see Item)
class ItemWidget extends StatefulWidget {
  final Item item;
  final void Function() onDelete;
  final void Function() onEdited;

  const ItemWidget(this.item,
      {required this.onDelete, required this.onEdited, super.key});

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
      checkbox = Checkbox(
        value: widget.item.isChecked,
        onChanged: _onNewCheckedState,
      );

      textDecoration =
          widget.item.isChecked ? TextDecoration.lineThrough : null;
    }

    return ListTile(
      leading: checkbox,
      onLongPress: _showOptionsModalSheet,
      title: Text(widget.item.value,
          style: itemTextStyle.copyWith(decoration: textDecoration)),
      onTap: _showEditDialog,
    );
  }

  void _onNewCheckedState(bool? value) {
    widget.item.isChecked = value!;
    updateThis();
  }

  void _showOptionsModalSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) => EditingActionsModalBottomSheet(
        actionButtons: [
          EditingActionButton.makeDeleteButton(onDelete: widget.onDelete)
        ],
      ),
    );
  }

  void _showEditDialog() {
    showDialog(
      context: context,
      builder: (context) => EditItemDialog(
          title: 'Edit Item', onSubmit: (_) => updateThis(), item: widget.item),
    );
  }

  void updateThis() {
    widget.onEdited();
    setState(() {});
  }
}