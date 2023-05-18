import 'package:flutter/material.dart';
import 'package:lists/model/item_group.dart';
import 'package:lists/view/edit_item_group_dialog.dart';

/// ItemGroupWidget:
///   - a widget representing an `ItemGroup`. Assumes `itemGroup.title != null`
class ItemGroupWidget extends StatefulWidget {
  final ItemGroup itemGroup;
  final void Function(ItemGroup) onEdited;
  const ItemGroupWidget(
      {super.key, required this.itemGroup, required this.onEdited});

  @override
  State<ItemGroupWidget> createState() => _ItemGroupWidgetState();
}

class _ItemGroupWidgetState extends State<ItemGroupWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async => await showDialog(
          context: context,
          builder: (context) => EditItemGroupDialog(
              itemGroup: widget.itemGroup,
              onSubmit: (itemGroup) {
                widget.onEdited(itemGroup);
                setState(() {});
              })),
      child: Text(widget.itemGroup.title!,
          style: Theme.of(context).textTheme.headlineLarge),
    );
  }
}
