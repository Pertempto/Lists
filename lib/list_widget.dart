import 'package:flutter/material.dart';

class ListWidget extends StatefulWidget {
  const ListWidget({super.key});

  @override
  State<ListWidget> createState() => _ListWidgetState();
}

class _ListWidgetState extends State<ListWidget> {
  static const itemTextStyle = TextStyle(fontSize: 20);

  final list = <Widget>[];

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
    // note:
    // I set children equal to a copy of list instead of just
    // list because ListView expects that its children parameter will
    // not be modified once it is passed in.
    //
    return ListView(
      children: list.toList(),
    );
  }

  void _addNewItem() {
    final itemToAdd = ListTile(
      title: Text(
        'New item',
        style: itemTextStyle,
      ),
    );

    setState(() => list.add(itemToAdd));
  }
}
