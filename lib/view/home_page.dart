import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:lists/model/list_model.dart';
import 'package:lists/model/database_manager.dart';
import 'package:lists/view/list_settings_dialog.dart';
import 'package:lists/view/list_widget.dart';
import 'package:lists/view/list_preview_widget.dart';
import 'package:lists/view/settings_widget.dart';
import 'package:lists/view/filter_dialog.dart';
import 'package:side_sheet/side_sheet.dart';

/// HomePage:
///   - A widget representing the home page in the app.
///     This is where the user selects the list they
///     want to view/edit.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<ListModel> data;
  late Iterable<String> allLabels;
  Set<String>? selectedLabels;

  late Future<void> startupFuture = _startup();
  Future<void> _startup() async =>
      data = await DatabaseManager.loadListModels();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Lists'),
          actions: [_buildFilterButton(), _buildSettingsButton()]),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddNewListDialog,
        tooltip: 'Create a new list',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildFilterButton() => IconButton(
      icon: const Icon(Icons.filter_alt),
      onPressed: () => showDialog(
          context: context,
          builder: (context) => FilterDialog(
                allLabels: allLabels,
                selectedLabels: selectedLabels,
                onSelectedLabelsChanged: (selectedLabels) =>
                    setState(() => this.selectedLabels = selectedLabels),
              )));

  Widget _buildSettingsButton() => IconButton(
      icon: const Icon(Icons.settings),
      onPressed: () =>
          SideSheet.right(context: context, body: const SettingsWidget()));

  Widget _buildBody() =>
      // We use the `data` only if `startupFuture` has completed (and loaded the
      // `ListModel`s from the database into `data`).
      FutureBuilder<void>(
          future: startupFuture,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              allLabels = _getAllLabels();
              // remove labels that are selected but have been deleted.
              selectedLabels =
                  selectedLabels?.where(allLabels.contains).toSet();
              // if there are no labels selected, set selectedLabels to null (which signifies no
              // filters, returning to the 'All' option).
              selectedLabels =
                  (selectedLabels?.isEmpty ?? true) ? null : selectedLabels;
              return _buildListPreviewsWidget();
            }
            if (snapshot.hasError) {
              _onListModelsLoadingError(snapshot.error!);
            }
            return Container();
          });

  Set<String> _getAllLabels() =>
      data.map((listModel) => listModel.labels).flattened.toSet();

  ListView _buildListPreviewsWidget() => ListView(
      children: _filteredData(data)
          .map((listModel) => ListPreviewWidget(
                listModel,
                onDelete: () async {
                  await DatabaseManager.deleteListModel(listModel);
                  setState(() => data.remove(listModel));
                },
                onEdited: () => setState(() {}),
                isLabelSelected: (label) =>
                    selectedLabels?.contains(label) ?? false,
                onLabelSelected: (label) => setState(() {
                  if (selectedLabels == null) {
                    selectedLabels = {label};
                  } else {
                    selectedLabels!.add(label);
                  }
                }),
                onLabelUnselected: (label) =>
                    setState(() => selectedLabels!.remove(label)),
                allLabels: allLabels,
              ))
          .toList());

  Iterable<ListModel> _filteredData(List<ListModel> data) =>
      selectedLabels == null
          ? data
          : data.where((listModel) => selectedLabels!.any(listModel.hasLabel));

  void _showAddNewListDialog() => showDialog(
        context: context,
        builder: (context) => ListSettingsDialog(
            onSubmit: _submitNewList,
            allLabels: allLabels,
            listModel: ListModel()),
      );

  void _submitNewList(ListModel listModel) async {
    final newListModel = await DatabaseManager.putListModel(listModel);
    if (context.mounted) {
      await Navigator.push(
          context, MaterialPageRoute(builder: (_) => ListWidget(newListModel)));
    }
    setState(() => data.add(listModel));
  }

  void _onListModelsLoadingError(Object error) {
    // TODO: handle error
    debugPrint(error.toString());
  }
}
