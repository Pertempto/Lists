import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  final String error;
  const ErrorDialog({super.key, this.error = 'Unknown error'});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Text('Error', style: TextStyle(color: Colors.red)),
        content: Text(error));
  }
}
