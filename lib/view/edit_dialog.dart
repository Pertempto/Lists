import 'package:flutter/material.dart';

class SubmitValueDialog extends StatefulWidget {
  final String title;
  final void Function(String) onSubmit;
  final String? initialText;
  const SubmitValueDialog(
      {super.key,
      required this.title,
      required this.onSubmit,
      this.initialText});

  @override
  State<SubmitValueDialog> createState() => _SubmitValueDialogState();
}

class _SubmitValueDialogState extends State<SubmitValueDialog> {
  late final TextEditingController _editingController;

  @override
  void initState() {
    _editingController = TextEditingController(text: widget.initialText);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title, textAlign: TextAlign.center),
      content: TextFormField(
        controller: _editingController,
        autofocus: true,
        onFieldSubmitted: (_) => _submitNewItemValue(),
      ),
      actions: [
        ElevatedButton(
          onPressed: () => _submitNewItemValue(),
          child: const Text('Submit'),
        )
      ],
    );
  }

  void _submitNewItemValue() {
    Navigator.pop(context);
    widget.onSubmit(_editingController.text);
  }
}
