import 'package:flutter/material.dart';
import 'package:lists/item.dart';

/// ItemWidget:
///   - a widget representing a single item
///   in a list (see Item)
class ItemWidget extends StatefulWidget {
  final Item item;
  const ItemWidget(this.item, {super.key});

  @override
  State<ItemWidget> createState() => _ItemWidgetState();
}

class _ItemWidgetState extends State<ItemWidget> {
  @override
  Widget build(BuildContext context) {
    final itemTextStyle = Theme.of(context).textTheme.titleLarge;

    return ListTile(
      title: TextFormField(
        autofocus:
            true, // this is here cause a newly-added item to be focused on immediately
        controller: widget.item.textEditingController,
        style: itemTextStyle,
        decoration: const InputDecoration(border: OutlineInputBorder()),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    widget.item.dispose();
  }
}
