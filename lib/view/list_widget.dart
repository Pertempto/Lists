import 'package:collection/collection.dart';
import 'package:lists/model/item.dart';
import 'package:lists/model/item_group.dart';
import 'package:lists/model/item_group_base.dart';
import 'package:lists/model/list_model.dart';
import 'package:flutter/material.dart';
import 'package:lists/view/edit_item_dialog.dart';
import 'package:lists/view/edit_item_group_dialog.dart';
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

  late Iterable<ItemGroupBase> groupsToBeDisplayed = listModel.groupsView();
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(listModel.title),
        actions: [
          SearchBar(
            onChanged: (searchQuery) async {
              this.searchQuery = searchQuery;
              await reFetchItems();
            },
          ),
          IconButton(
            icon: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [const Icon(Icons.add), const Icon(Icons.category)]),
            onPressed: () => showDialog(
              context: context,
              builder: (context) => EditItemGroupDialog(
                itemGroup: ItemGroup(),
                onSubmit: (itemGroup) async {
                  await listModel
                      .addGroup(await itemGroup.asDatabaseItemGroup());
                  await reFetchItems();
                },
              ),
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

  ListView _buildBody() => ListView(
      children: groupsToBeDisplayed
          .map((group) => <Widget>[
                InkWell(
                  onTap: () async {
                    await showDialog(
                        context: context,
                        builder: (context) => EditItemGroupDialog(
                            itemGroup: group,
                            onSubmit: (itemGroup) async {
                              await listModel.updateGroup(
                                  await itemGroup.asDatabaseItemGroup());
                              setState(() {});
                            }));
                  },
                  child: Text(group.title ?? 'Cheese',
                      style: Theme.of(context).textTheme.headlineLarge),
                )
              ].followedBy(group.itemsView().map((item) => ItemWidget(item,
                      listModel: widget.listModel, onDelete: () async {
                    await listModel.remove(item);
                    await reFetchItems();
                  }, onEdited: () async {
                    try {
                      await listModel.update(item);
                      await reFetchItems();
                    } on ItemUpdateError catch (e) {
                      // TODO: handle item update error.
                      debugPrint('ERROR: $e');
                    }
                  }))))
          .flattened
          .toList());

  void _addNewItem() async {
    final newItem = Item();

    if (context.mounted) {
      showDialog(
        context: context,
        builder: (context) => EditItemDialog(
            containingListModel: listModel,
            onSubmit: (newItem) async {
              await listModel.add(newItem);
              await reFetchItems();
            },
            item: newItem),
      );
    }
  }

  Future<void> reFetchItems() async {
    groupsToBeDisplayed = await listModel.searchItems(searchQuery);
    setState(() {});
  }
}
