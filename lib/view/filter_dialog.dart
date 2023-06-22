import 'package:flutter/material.dart';

/// FilterSideSheet:
///   -
class FilterDialog extends StatefulWidget {
  final Iterable<String> allLabels;
  final Iterable<String>? selectedLabels;
  final void Function(Iterable<String>?) onSelectedLabelsChanged;

  const FilterDialog(
      {super.key,
      required this.allLabels,
      required this.selectedLabels,
      required this.onSelectedLabelsChanged});

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  late final Set<String> _selectedLabels = widget.selectedLabels?.toSet() ?? {};

  // convenience getter. `onSelectedLabelsChanged` is called with the value of this getter.
  Set<String>? get _selectedLabelsIfNotEmpty =>
      _selectedLabels.isNotEmpty ? _selectedLabels : null;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Filter',
          style: Theme.of(context).textTheme.titleLarge,
          textAlign: TextAlign.center),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: const EdgeInsets.only(left: 4.0),
              child: Text('Labels',
                  style: Theme.of(context).textTheme.titleMedium)),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLabelsWidget(),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildLabelsWidget() => SizedBox(
        width: 240,
        child: Wrap(
            spacing: 4,
            runSpacing: 4,
            children: <Widget>[
              ChoiceChip(
                label: const Text('All'),
                selected: _selectedLabels.isEmpty,
                onSelected: (isSelected) {
                  setState(() => isSelected ? _selectedLabels.clear() : null);
                  widget.onSelectedLabelsChanged(_selectedLabelsIfNotEmpty);
                },
              )
            ]
                .followedBy(widget.allLabels.map((label) => FilterChip(
                    label: Text(label),
                    selected: _selectedLabels.contains(label),
                    onSelected: (isSelected) {
                      setState(() => isSelected
                          ? _selectedLabels.add(label)
                          : _selectedLabels.remove(label));
                      widget.onSelectedLabelsChanged(_selectedLabelsIfNotEmpty);
                    })))
                .toList()),
      );
}
