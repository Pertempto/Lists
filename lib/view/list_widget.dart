import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:document_file_save_plus/document_file_save_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:lists/model/item.dart';
import 'package:lists/model/list_model.dart';
import 'package:flutter/material.dart' hide SearchBar;
import 'package:lists/view/edit_item_dialog.dart';
import 'package:lists/view/search_bar.dart';
import 'package:lists/view/item_widget.dart';
import 'package:reorderables/reorderables.dart';

import 'export_as_markdown_mobile_dialog.dart';

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
          PopupMenuButton(
              child: const Icon(Icons.more_vert),
              itemBuilder: (context) => [
                    PopupMenuItem(
                        onTap: _exportAsMarkdown,
                        child: const Text('Export as Markdown'))
                  ]),
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

    return CustomScrollView(slivers: [
      unCheckedItemWidgetsSliver,
      if (checkedItems.isNotEmpty) dividerSliver,
      checkedItemWidgetsSliver
    ]);
  }

  List<Widget> _buildItemWidgets(
          {required Iterable<Item> fromItems, bool tappable = true}) =>
      fromItems
          .map((item) => ItemWidget(item,
              tappable: tappable,
              onDelete: () async => await listModel.remove(item),
              onEdited: () async => await listModel.update(item)))
          .toList();

  void _addNewItem() async {
    // Imitate the type of the last item.
    final newItem = Item('', listModel.lastItemType);

    if (context.mounted) {
      showDialog(
        context: context,
        builder: (context) => EditItemDialog(
            onSubmit: (newItem) async => await listModel.add(newItem),
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

  Future<void> _exportAsMarkdown() async {
    // We have to have separate exportAsMarkdown functions for mobile and desktop
    // because the file_picker package (https://pub.dev/packages/file_picker) only
    // supports saving files in desktop. This package seemed far superior to its competitors.
    if (Platform.isAndroid || Platform.isIOS) {
      await _exportAsMarkdownOnMobile();
    } else {
      await _exportAsMarkdownOnDesktop();
    }
  }

  Future<void> _exportAsMarkdownOnDesktop() async => await showDialog(
      context: context,
      builder: (context) => ExportListAsMarkdownDialog(
          listModel: listModel,
          includeFileNameTextField: false,
          onExport: (filename, markdown) async {
            final filePath = await FilePicker.platform.saveFile(
                fileName: filename,
                type: FileType.custom,
                allowedExtensions: ['md']);

            if (filePath != null) {
              await File(filePath).writeAsString(markdown);
              _onSuccessfulMarkdownExport();
            }
          }));

  Future<void> _exportAsMarkdownOnMobile() async => await showDialog(
      context: context,
      builder: (context) => ExportListAsMarkdownDialog(
          listModel: listModel,
          includeFileNameTextField: true,
          onExport: (filename, markdown) async {
            await DocumentFileSavePlus.saveFile(
                Uint8List.fromList(markdown.codeUnits),
                filename,
                'text/markdown');
            _onSuccessfulMarkdownExport();
          }));

  void _onSuccessfulMarkdownExport() {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Exported as Markdown successfully')));
    }
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
