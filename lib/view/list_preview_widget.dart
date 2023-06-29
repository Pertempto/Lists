import 'package:flutter/material.dart';
import 'package:lists/model/list_model.dart';
import 'package:lists/view/editing_actions_modal_bottom_sheet.dart';
import 'package:lists/view/list_widget.dart';
import 'package:lists/view/list_settings_dialog.dart';
import 'package:lists/model/database_manager.dart';

/// ListPreviewWidget:
///   - a widget representing a tile which contains the metadata
///     about a ListModel. When selected, pushes a ListWidget
///     representing this ListModel.
class ListPreviewWidget extends StatefulWidget {
  final ListModel listModel;
  final void Function() onDelete;
  final void Function() onEdited;
  final Iterable<String> allLabels;

  const ListPreviewWidget(this.listModel,
      {super.key,
      required this.onDelete,
      required this.onEdited,
      required this.allLabels});

  @override
  State<ListPreviewWidget> createState() => _ListPreviewWidgetState();
}

class _ListPreviewWidgetState extends State<ListPreviewWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await Navigator.push(context,
            MaterialPageRoute(builder: (_) => ListWidget(widget.listModel)));
        setState(() {});
      },
      onLongPress: _showOptionsModalSheet,
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Icon(Icons.list),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.listModel.title,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: Theme.of(context).textTheme.titleLarge),
                  Text('Items: ${widget.listModel.items.length}'),
                ],
              ),
            ),
          ),
          if (widget.listModel.labels
              .isNotEmpty) // if the list has no labels, then don't create a widget to display the list's labels
            Container(
              // Use half of the screen width, to make it look good on different
              // screen sizes.
              width: MediaQuery.of(context).size.width * 0.5,
              padding: const EdgeInsets.all(8),
              child: Wrap(
                  alignment: WrapAlignment.end,
                  spacing: 4.0,
                  runSpacing: 4.0,
                  children: widget.listModel.labels
                      .map((label) => Chip(
                            label: Text(label,
                                style: Theme.of(context).textTheme.labelSmall),
                          ))
                      .toList()),
            )
        ],
      ),
    );
  }

  void _showOptionsModalSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) => EditingActionsModalBottomSheet(
        actionButtons: [
          EditingActionButton.deleteButton(onDelete: widget.onDelete),
          EditingActionButton.editButton(
              onPressed: () => showDialog(
                  context: context,
                  builder: (context) => ListSettingsDialog(
                      onSubmit: (listModel) async {
                        await DatabaseManager.putListModel(listModel);
                        setState(() {});
                        widget.onEdited();
                      },
                      listModel: widget.listModel,
                      allLabels: widget.allLabels))),
        ],
      ),
    );
  }
}
