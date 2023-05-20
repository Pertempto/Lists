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
        width: 160,
        child: TextField(
          controller: editingController,
          onChanged: widget.onChanged,
          decoration: const InputDecoration(
              hintText: "Search in list", suffixIcon: Icon(Icons.search)),
        ));
  }
}
