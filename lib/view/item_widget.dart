import 'package:flutter/material.dart';
import 'package:lists/model/item.dart';

/// ItemWidget:
///   - a widget representing the view of a single item
///     in a list (see Item)
class ItemWidget extends StatefulWidget {
  final Item item;
  const ItemWidget(this.item, {super.key});

  @override
  State<ItemWidget> createState() => _ItemWidgetState();
}

class _ItemWidgetState extends State<ItemWidget> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final itemTextStyle = Theme.of(context).textTheme.titleLarge;
    return ListTile(
      title: Text(widget.item.value, style: itemTextStyle),
      onTap: _showEditDialog,
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
