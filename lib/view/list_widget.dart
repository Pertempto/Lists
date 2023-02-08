import 'package:flutter/material.dart';
import 'package:lists/model/item.dart';
import 'package:lists/model/utils.dart';
import 'package:lists/view/item_widget.dart';

/// ListWidget:
///   - a widget representing a page containing a single list in the
///     app, such as a to-do list, a shopping list, etc.
class ListWidget extends StatefulWidget {
  const ListWidget({super.key});

  @override
  State<ListWidget> createState() => _ListWidgetState();
}

class _ListWidgetState extends State<ListWidget> {
  final listItems = <Item>[];

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
          children: Utils.mapIndexed(
        listItems,
        _buildItemWidget,
      ).toList());

  ItemWidget _buildItemWidget(int index, Item item) => ItemWidget(item,
      deleteThisItem: () => setState(() => listItems.removeAt(index)));

  void _addNewItem() {
    setState(() => listItems.add(Item()));
  }
}
