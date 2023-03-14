import 'package:flutter/material.dart';
import 'package:lists/model/item.dart';
import 'package:lists/view/edit_dialog.dart';
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
    final itemTextStyle = Theme.of(context).textTheme.titleLarge;
    return ListTile(
      onLongPress: _showOptionsModalSheet,
      title: Text(widget.item.value, style: itemTextStyle),
      onTap: _showEditDialog,
    );
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
      builder: (context) => SubmitValueDialog(
          title: "Enter Item",
          onSubmit: updateItemValue,
          initialText: widget.item.value),
    );
  }

  void updateItemValue(String newValue) => setState(() {
        widget.item.value = newValue;
        widget.onEdited();
      });
}
