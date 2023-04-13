import 'package:lists/model/item.dart';
import 'package:lists/model/list_model.dart';
import 'package:flutter/material.dart';
import 'package:lists/view/edit_item_dialog.dart';
import 'package:lists/view/error_dialog.dart';
import 'package:lists/view/item_widget.dart';

/// ListWidget:
///   - a widget representing a ListModel
class ListWidget extends StatefulWidget {
  final ListModel listModel;
  const ListWidget(this.listModel, {super.key});

  @override
  State<ListWidget> createState() => _ListWidgetState();
}

class _ListWidgetState extends State<ListWidget> {
  ListModel get listModel => widget.listModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(listModel.title)),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewItem,
        tooltip: 'Add a new item',
        child: const Icon(Icons.add),
      ),
    );
  }

  ListView _buildBody() => ListView(
      children: listModel
          .itemsView()
          .map((item) => ItemWidget(item, onDelete: () async {
                await listModel.remove(item);
                setState(() {});
              }, onEdited: () async {
                try {
                  await listModel.update(item);
                } on ItemUpdateError catch (e) {
                  // TODO: handle item update error.
                  debugPrint(e.toString());
                }
              }))
          .toList());

  void _addNewItem() async {
    final newItem = Item();

    if (context.mounted) {
      showDialog(
        context: context,
        builder: (context) => EditItemDialog(
            title: 'New Item',
            onSubmit: (newItem) async {
              await listModel.add(newItem);
              setState(() {});
            },
            item: newItem),
      );
    }
  }
}