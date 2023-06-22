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
  final Iterable<String> allLabels;

  const ListPreviewWidget(this.listModel, {super.key, required this.onDelete, required this.allLabels});

  @override
  State<ListPreviewWidget> createState() => _ListPreviewWidgetState();
}

class _ListPreviewWidgetState extends State<ListPreviewWidget> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.list),
      isThreeLine: true,
      onTap: () async {
        await Navigator.push(context,
            MaterialPageRoute(builder: (_) => ListWidget(widget.listModel)));
        setState(() {});
      },
      onLongPress: _showOptionsModalSheet,
      title: Text(widget.listModel.title,
          style: Theme.of(context).textTheme.titleLarge),
      subtitle: Text('Items: ${widget.listModel.items.length}'),
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
                      },
                      listModel: widget.listModel, allLabels: widget.allLabels))),
        ],
      ),
    );
  }
}
