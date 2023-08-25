import 'dart:async';

import 'package:collection/collection.dart';
import 'package:lists/model/item.dart';
import 'package:lists/model/list_model.dart';
import 'package:flutter/material.dart';
import 'package:lists/view/edit_item_dialog.dart';
import 'package:lists/view/search_bar.dart';
import 'package:lists/view/item_widget.dart';
import 'package:reorderables/reorderables.dart';

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
  bool isReordering = false;

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

  Widget _buildBody() {
    bool isItemChecked(Item item) =>
        (item.itemType == ItemType.checkbox && item.isChecked);

    final unCheckedItems = _ordered(itemsToBeDisplayed.whereNot(isItemChecked));
    final checkedItems = _ordered(itemsToBeDisplayed.where(isItemChecked));

    final unCheckedItemWidgetsSliver = searchQuery.isEmpty
        ? ReorderableSliverList(
            delegate: ReorderableSliverChildListDelegate(
                _buildItemWidgets(fromItems: unCheckedItems)),
            // Note onReorder can't be async (which would allow us to `await` for the
            // ordering of the items to be updated) because if it was, the list would
            // sometimes flicker briefly between the old ordering and the new ordering (tested).
            onReorder: (oldIndex, newIndex) {
              int oldOrder = unCheckedItems[oldIndex].order;
              int newOrder = unCheckedItems[newIndex].order;
              listModel.reorderItem(oldOrder: oldOrder, newOrder: newOrder);
              // We set `itemsToBeDisplayed` to `listModel.itemsView()` because
              // 1) `reorderItem` uses `DatabaseManager.putItems` to update the ordering of the
              // items, which is asynchronous, meaning that the items in the database may not be
              // updated. However the function does update the `IsarLinks` cached copy
              // of the items (which is `listModel.itemsView()`) synchronously. Also,
              // 2) if the user previously searched the items, then `itemsToBeDisplayed`
              // holds a copy of the `listModel`'s items separate from the `IsarLinks`, and
              // so is not updated.
              // So, `listModel.itemsView()` holds the only updated copy of the
              // `listModel`'s items.

              setState(() => itemsToBeDisplayed = listModel.itemsView());
            },
            onDragStart: () => setState(() => isReordering = true),
            onDragEnd: () => setState(() => isReordering = false),
          )
        : SliverList(
            delegate: SliverChildListDelegate(
                _buildItemWidgets(fromItems: unCheckedItems)));

    final dividerSliver = SliverList(
        delegate: SliverChildListDelegate([Divider(key: UniqueKey())]));

    final checkedItemWidgetsSliver = SliverList(
        delegate: SliverChildListDelegate(_buildItemWidgets(
            fromItems: checkedItems, tappable: !isReordering)));

    return CustomScrollView(slivers: [
      unCheckedItemWidgetsSliver,
      if (checkedItems.isNotEmpty) dividerSliver,
      checkedItemWidgetsSliver
    ]);
  }

  List<Widget> _buildItemWidgets({required Iterable<Item> fromItems, bool tappable = true}) =>
      fromItems.map((item) => ItemWidget(item,tappable: tappable,  onDelete: () async =>
            await listModel.remove(item), onEdited: () async =>
            await listModel.update(item))).toList();

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

  List<Item> _ordered(Iterable<Item> items) =>
      items.sorted((a, b) => a.order - b.order);
      
  @override
  void dispose() {
    // Note we don't need to await for the subscription to cancel;
    // this call is needed just so that unneeded and unreferenced 
    // subscriptions are removed from listModel's eventStream.
    eventStreamSubscription.cancel();
    super.dispose();
  }
}
