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

  ListView _buildBody() => ListView(
      children: itemsToBeDisplayed
          .map((item) => ItemWidget(item, onDelete: () async {
                await listModel.remove(item);
                await refreshItems();
              }, onEdited: () async {
                try {
                  if (item.isRepeating) {
                    item.setScheduledTimer(callback: listModel.update);
                  } else {
                    item.scheduledTimer?.cancel();
                  }
                  await listModel.update(item);
                } on ItemUpdateError catch (e) {
                  // TODO: handle item update error.
                  debugPrint(e.toString());
                }
              }))
          .toList());

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
}
