import 'package:flutter/material.dart';

///ListWidget: 
///  - a widget representing a page containing a single list in the 
///  app, such as a to-do list, a shopping list, etc.

class ListWidget extends StatefulWidget {
  const ListWidget({super.key});

  @override
  State<ListWidget> createState() => _ListWidgetState();
}

class _ListWidgetState extends State<ListWidget> {
  final listItems = <String>[];

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

  ListView _buildListView() {
    return ListView(
      children: listItems
          .map(
            (item) => _buildItemWidget(item),
          )
          .toList(),
    );
  }

  Widget _buildItemWidget(String item) {
    final itemTextStyle = Theme.of(context).textTheme.titleLarge;
    return ListTile(
      title: Text(
        item,
        style: itemTextStyle,
      ),
    );
  }

  void _addNewItem() {
    final itemToAdd = 'New Item';

    setState(() => listItems.add(itemToAdd));
  }
}
