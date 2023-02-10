import 'package:flutter/material.dart';
import 'package:lists/model/item.dart';

/// ItemWidget:
///   - a widget representing the view of a single item
///     in a list (see Item)
class ItemWidget extends StatefulWidget {
  final Item item;
  final void Function() onDelete;
  const ItemWidget(this.item, {required this.onDelete, super.key});

  @override
  State<ItemWidget> createState() => _ItemWidgetState();
}

class _ItemWidgetState extends State<ItemWidget> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final itemTextStyle = Theme.of(context).textTheme.titleLarge;
    return ListTile(
      leading: IconButton(
        icon: Icon(Icons.delete),
        onPressed: _showConfirmDeleteDialog,
      ),
      title: Text(widget.item.value, style: itemTextStyle),
      onTap: _showEditDialog,
    );
  }

  void _showConfirmDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete this item?", textAlign: TextAlign.center),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Icon(Icons.close),
          ),
          TextButton(
            onPressed: () {
              widget.onDelete();
              Navigator.pop(context);
            },
            child: const Icon(Icons.check, color: Colors.red),
          ),
        ],
      ),
    );
  }

  void _showEditDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Enter Item", textAlign: TextAlign.center),
        content: TextFormField(
          controller: _textEditingController,
          autofocus: true,
          onFieldSubmitted: (_) => _submitNewItemValue(context: context),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => _submitNewItemValue(context: context),
            child: const Text('Submit'),
          )
        ],
      ),
    );
  }

  void _submitNewItemValue({required BuildContext context}) {
    updateItemValue(_textEditingController.text);
    Navigator.pop(context);
  }

  void updateItemValue(String newValue) =>
      setState(() => widget.item.value = newValue);
}
