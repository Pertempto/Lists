import 'dart:async';

import 'package:collection/collection.dart';
import 'package:lists/model/item.dart';
import 'package:lists/model/list_model.dart';
import 'package:flutter/material.dart';
import 'package:lists/view/edit_item_dialog.dart';
import 'package:lists/view/search_bar.dart';
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

  late Iterable<Item> itemsToBeDisplayed;
  String searchQuery = '';

  late final StreamSubscription<ListModelEvent> eventStreamSubscription;

  @override
  void initState() {
    super.initState();
    itemsToBeDisplayed = listModel.itemsView();
    eventStreamSubscription =
        listModel.eventStream.listen((event) async => await refreshItems());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(listModel.title),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: SearchBar(
              onChanged: (searchQuery) async {
                this.searchQuery = searchQuery;
                await refreshItems();
              },
            ),
          ),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: Visibility(
        visible: searchQuery.isEmpty,
        child: FloatingActionButton(
          onPressed: _addNewItem,
          tooltip: 'Add a new item',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  ListView _buildBody() {
    bool isItemChecked(Item item) =>
        (item.itemType == ItemType.checkbox && item.isChecked);

    final unCheckedItems = itemsToBeDisplayed.whereNot(isItemChecked);
    final checkedItems = itemsToBeDisplayed.where(isItemChecked);

    return ListView(
        children: _buildItemWidgets(fromItems: unCheckedItems)
            .followedBy([if (checkedItems.isNotEmpty) const Divider()])
            .followedBy(_buildItemWidgets(fromItems: checkedItems))
            .toList());
  }

  Iterable<Widget> _buildItemWidgets({required Iterable<Item> fromItems}) =>
      fromItems.map((item) => ItemWidget(item, onDelete: () async =>
            await listModel.remove(item), onEdited: () async =>
            await listModel.update(item)));

  void _addNewItem() async {
    // Imitate the type of the last item.
    final newItem = Item('', listModel.lastItemType);

    if (context.mounted) {
      showDialog(
        context: context,
        builder: (context) => EditItemDialog(
            onSubmit: (newItem) async =>
              await listModel.add(newItem),
            item: newItem),
      );
    }
  }

  Future<void> refreshItems() async {
    itemsToBeDisplayed = await listModel.searchItems(searchQuery);
    setState(() {});
  }

  @override
  void dispose() {
    // Note we don't need to await for the subscription to cancel;
    // this call is needed just so that unneeded and unreferenced 
    // subscriptions are removed from listModel's eventStream.
    eventStreamSubscription.cancel();
    super.dispose();
  }
}
