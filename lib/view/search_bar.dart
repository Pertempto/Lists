import 'package:flutter/material.dart';

/// SearchBar:
///   - a widget representing a search bar.
class SearchBar extends StatefulWidget {
  final void Function(String)? onChanged;

  const SearchBar({super.key, this.onChanged});

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final TextEditingController editingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 130,
        child: TextField(
          controller: editingController,
          onChanged: widget.onChanged,
          decoration: InputDecoration(
              icon: const Icon(Icons.search),
              suffixIcon: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  editingController.clear();
                  if (widget.onChanged != null) widget.onChanged!('');
                },
              )),
        ));
  }
}
