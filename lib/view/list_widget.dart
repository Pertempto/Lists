import 'package:collection/collection.dart';
import 'package:lists/model/lists_database_manager.dart';
import 'package:lists/model/list_model.dart';
import 'package:flutter/material.dart';
import 'package:lists/model/item.dart';
import 'package:lists/view/item_widget.dart';

/// ListWidget:
///   - a widget representing a page containing a single list in the
///     app, such as a to-do list, a shopping list, etc.
class ListWidget extends StatefulWidget {
  final ListModel listModel;
  const ListWidget(this.listModel, {super.key});

  @override
  State<ListWidget> createState() => _ListWidgetState();
}

class _ListWidgetState extends State<ListWidget> {
  // convenience getter to remove redundant code
  ListModel get listModel => widget.listModel;
  List<Item> get listItems => widget.listModel.items;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lists'),
      ),
      body: _buildListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewItem,
        tooltip: 'Add a new item',
        child: const Icon(Icons.add),
      ),
    );
  }

  ListView _buildListView() => ListView(
      children: listItems
          .mapIndexed((index, item) => ItemWidget(
                item,
                onDelete: () => setState(() {
                  listItems.removeAt(index);
                  ListsDatabaseManager.update(listModel);
                }),
                onNewValue: () {
                  ListsDatabaseManager.update(listModel);
                },
              ))
          .toList());

  void _addNewItem() => setState(() {
        listItems.add(Item());
        ListsDatabaseManager.update(listModel);
      });
}
