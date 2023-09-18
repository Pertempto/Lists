import 'package:flutter/material.dart';

/// SearchField:
///   - a widget representing a search field.
class SearchField extends StatefulWidget {
  final void Function(String)? onChanged;
  final void Function()? onFocus;

  const SearchField({super.key, this.onChanged, this.onFocus});

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  final TextEditingController editingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus && widget.onFocus != null) {
        widget.onFocus!();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 160,
        child: TextField(
          controller: editingController,
          onChanged: widget.onChanged,
          decoration: const InputDecoration(
              hintText: "Search in list", suffixIcon: Icon(Icons.search)),
          focusNode: _focusNode,
        ));
  }
}
