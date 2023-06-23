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

  // Convenience getter. `onSelectedLabelsChanged` is called with the value of this getter.
  Set<String>? get _selectedLabelsIfNotEmpty =>
      _selectedLabels.isNotEmpty ? _selectedLabels : null;

  /// The following getter is useful in one particular case: Let's say the user
  /// selects a label and then deletes that label from every list that has it.
  /// Now, that label is not contained in `allLabels` (because no list has
  /// that label), but is contained in `selectedLabels` (because the user never
  /// unselected it). That label is now 'deleted.' This getter returns deleted
  /// labels.
  Iterable<String> get _deletedLabels =>
      _selectedLabels.difference(widget.allLabels.toSet());

  static const _deletedLabelTextStyle = TextStyle(
      fontStyle: FontStyle.italic, decoration: TextDecoration.lineThrough);

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
                .followedBy(_createLabelChips(
                    labels: widget.allLabels, areDeleted: false))
                .followedBy(
                    _createLabelChips(labels: _deletedLabels, areDeleted: true))
                .toList()),
      );

  Iterable<FilterChip> _createLabelChips({
    required Iterable<String> labels,
    required bool areDeleted,
  }) {
    // a different styling is used for when the passed labels are deleted
    final labelTextStyle = areDeleted ? _deletedLabelTextStyle : null;
    final chipSelectedColor = areDeleted ? Colors.red : null;

    return labels.map(
      (label) => FilterChip(
          label: Text(label, style: labelTextStyle),
          selectedColor: chipSelectedColor,
          selected: _selectedLabels.contains(label),
          onSelected: (isSelected) {
            setState(() => isSelected
                ? _selectedLabels.add(label)
                : _selectedLabels.remove(label));
            widget.onSelectedLabelsChanged(_selectedLabelsIfNotEmpty);
          }),
    );
  }
}
