import 'package:flutter/material.dart';
import 'package:lists/model/list_model.dart';
import 'package:lists/view/editing_actions_modal_bottom_sheet.dart';
import 'package:lists/view/list_widget.dart';

/// ListPreviewWidget:
///   - a widget representing a tile which contains the metadata 
///     about a ListModel. When selected, pushes a ListWidget 
///     representing this ListModel.     
class ListPreviewWidget extends StatefulWidget {
  final ListModel listModel;
  final void Function() onDelete;

  const ListPreviewWidget(this.listModel, {super.key, required this.onDelete});

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
          EditingActionButton.makeDeleteButton(
              onDelete: widget.onDelete)
        ],
      ),
    );
  }
}
