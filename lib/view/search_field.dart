import 'package:flutter/material.dart';

/// SearchField:
///   - a widget representing a search field.
class SearchField extends StatefulWidget {
  final void Function(String)? onChanged;

  const SearchField({super.key, this.onChanged});

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  final TextEditingController editingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 160,
        child: TextField(
          controller: editingController,
          onChanged: widget.onChanged,
          decoration: const InputDecoration(
              hintText: "Search in list", suffixIcon: Icon(Icons.search)),
        ));
  }
}
