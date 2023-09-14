import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart' hide SearchBar;
import 'package:lists/model/item.dart';
import 'package:lists/model/list_model.dart';
import 'package:lists/view/item_widget.dart';
import 'package:lists/view/repeat_dialog.dart';
import 'package:lists/view/search_bar.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:reorderables/reorderables.dart';

import '../model/item_scheduling.dart';

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
  Item? selectedItem;

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
    return GestureDetector(
        child: Scaffold(
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
        ),
        onTap: () => setState(() => selectedItem = null));
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
            onReorder: (oldIndex, newIndex) {
              // Move the item
              var item = unCheckedItems.removeAt(oldIndex);
              unCheckedItems.insert(newIndex, item);
              // Update the order values
              var combined = unCheckedItems + checkedItems;
              combined
                  .forEachIndexed((index, element) => element.order = index);
              // Save to DB
              listModel.reorderItems(combined);
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

    return Column(
      children: [
        Expanded(
          child: CustomScrollView(
            slivers: [
              unCheckedItemWidgetsSliver,
              if (checkedItems.isNotEmpty) dividerSliver,
              checkedItemWidgetsSliver
            ],
            shrinkWrap: true,
          ),
        ),
        _buildToolBar()
      ],
    );
  }

  List<Widget> _buildItemWidgets(
          {required Iterable<Item> fromItems, bool tappable = true}) =>
      fromItems
          .map((item) => ItemWidget(item,
              tappable: tappable,
              onFocus: () => setState(() => selectedItem = item),
              onUpdate: () => listModel.update(item),
              key: Key(item.id.toString())))
          .toList();

  void _addNewItem() async {
    // Imitate the type of the last item.
    final newItem = Item('', listModel.lastItemType);
    await listModel.add(newItem);
  }

  Widget _buildToolBar() {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    // Create a local variable to store the item, so that it will be promoted
    // to non-nullable type inside null-check
    // See https://stackoverflow.com/a/65035575

    var item = selectedItem;
    return Container(
      color: colorScheme.surfaceVariant,
      child: Row(
        children: item != null
            ? [
                if (item.itemType == ItemType.checkbox)
                  IconButton(
                    onPressed: () {
                      item.itemType = ItemType.text;
                      item.scheduling = null;
                      listModel.update(item);
                    },
                    icon: Icon(MdiIcons.checkboxBlankOffOutline),
                  ),
                if (item.itemType == ItemType.text)
                  IconButton(
                    onPressed: () {
                      item.itemType = ItemType.checkbox;
                      listModel.update(item);
                    },
                    icon: const Icon(Icons.check_box_outlined),
                  ),
                if (item.itemType == ItemType.checkbox)
                  IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) => RepeatDialog(
                              onSubmit: (config) {
                                item.scheduling =
                                    ItemScheduling.fromRepeatConfig(config);
                                listModel.update(item);
                              },
                              repeatConfig: item.scheduling?.repeatConfig));
                    },
                    icon: const Icon(Icons.repeat),
                  ),
                if (item.scheduling != null)
                  IconButton(
                    onPressed: () {
                      item.scheduling = null;
                      listModel.update(item);
                    },
                    icon: Icon(MdiIcons.repeatOff),
                  ),
                IconButton(
                  onPressed: () {
                    listModel.remove(item);
                    setState(() => selectedItem = null);
                  },
                  icon: const Icon(Icons.delete),
                ),
              ]
            : [],
      ),
    );
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
