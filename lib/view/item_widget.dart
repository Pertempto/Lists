import 'package:flutter/material.dart';
import 'package:lists/model/item.dart';

/// ItemWidget:
///   - a widget representing the view of a single item
///   in a list (see Item)
class ItemWidget extends StatefulWidget {
  final Item item;
  const ItemWidget(this.item, {super.key});

  @override
  State<ItemWidget> createState() => _ItemWidgetState();
}

class _ItemWidgetState extends State<ItemWidget> {
  // I think it is better to have a the TextEditingController in the
  // State rather than the widget (since the user of the widget doesn't
  // need to access the controller), but I am open to other views.
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
          title: _buildEditDialogTitle(context),
          content: _buildEditDialogContent(context),
          actions: [_buildSubmitButton(context)]),
    );
  }

  Widget _buildEditDialogTitle(BuildContext context) =>
      const Text("Enter Item", textAlign: TextAlign.center);

  Widget _buildEditDialogContent(BuildContext context) {
    return TextFormField(
      controller: _textEditingController,
      autofocus: true,
      // Note: I know there is some duplication here, since the user
      // can submit an item both through the submit action button and
      // pressing enter in the text form field. Is this duplication useful.
      onFieldSubmitted: (_) => _submitNewItemValue(context: context),
    );
  }

  void _submitNewItemValue({required BuildContext context}) {
    updateItemValue(_textEditingController.text);
    Navigator.pop(context);
  }

  void updateItemValue(String newValue) =>
      setState(() => widget.item.value = newValue);

  ElevatedButton _buildSubmitButton(BuildContext context) => ElevatedButton(
      onPressed: () => _submitNewItemValue(context: context),
      child: const Text('Submit'));
}
