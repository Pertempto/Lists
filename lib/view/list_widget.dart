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

  @override
  void initState() {
    super.initState();
    listModel.reload();
    itemsToBeDisplayed = listModel.itemsView();
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
                _buildItemWidgets(fromItems: unCheckedItems).toList()),
            onReorder: (oldIndex, newIndex) {
              final from = unCheckedItems[oldIndex].order;
              final to = oldIndex < newIndex
                  ? unCheckedItems[newIndex].order + 1
                  : unCheckedItems[newIndex].order;

              listModel.moveItem(from: from, to: to);
              // We set `itemsToBeDisplayed` to `listModel.itemsView()` because
              // 1) `moveItem` puts the moved items to the database asynchronously (so we can't
              // load the items from the database), but updates the `IsarLinks` cached copy
              // of them (`listModel.itemsView()`) synchronously, and
              // 2) if the user previously searched the items, then `itemsToBeDisplayed`
              // holds a copy of the `listModel`'s items separate from the `IsarLinks`, and
              // so is not updated.
              // So, `listModel.itemsView()` holds the only updated copy of the
              // `listModel`'s items.
              setState(() => itemsToBeDisplayed = listModel.itemsView());
              print(itemsToBeDisplayed.map((e) => e.order).toList());
            })
        : SliverList(
            delegate: SliverChildListDelegate(
                _buildItemWidgets(fromItems: unCheckedItems).toList()),
          );
    final dividerSliver = SliverList(
        delegate: SliverChildListDelegate.fixed(
            [if (checkedItems.isNotEmpty) Divider(key: UniqueKey())]));
    final checkedItemWidgetsSliver = SliverList(
        delegate: SliverChildListDelegate(
            _buildItemWidgets(fromItems: checkedItems).toList()));

    return CustomScrollView(slivers: [
      unCheckedItemWidgetsSliver,
      dividerSliver,
      checkedItemWidgetsSliver
    ]);
  }

  Iterable<Widget> _buildItemWidgets({required Iterable<Item> fromItems}) =>
      fromItems.map((item) => ItemWidget(item, onDelete: () async {
            await listModel.remove(item);
            await refreshItems();
          }, onEdited: () async {
            try {
              await listModel.update(item);
              await refreshItems();
            } on ItemUpdateError catch (e) {
              // TODO: handle item update error.
              debugPrint(e.toString());
            }
          }, key: ValueKey(item.id)));

  void _addNewItem() async {
    // Imitate the type of the last item.
    final newItem = Item('', listModel.lastItemType);

    if (context.mounted) {
      showDialog(
        context: context,
        builder: (context) => EditItemDialog(
            onSubmit: (newItem) async {
              await listModel.add(newItem);
              await refreshItems();
            },
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
}
