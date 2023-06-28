import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:lists/model/list_model.dart';
import 'package:lists/model/database_manager.dart';
import 'package:lists/view/list_settings_dialog.dart';
import 'package:lists/view/list_widget.dart';
import 'package:lists/view/list_preview_widget.dart';
import 'package:lists/view/settings_widget.dart';
import 'package:modal_side_sheet/modal_side_sheet.dart';
import 'package:lists/view/filter_dialog.dart';

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
  late Iterable<String> allLabels;
  Iterable<String>? selectedLabels;
  bool showFilterSideSheet = false;

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
          showModalSideSheet(context: context, body: const SettingsWidget()));

  Widget _buildBody() => FutureBuilder<List<ListModel>>(
      future: DatabaseManager.loadListModels(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          allLabels = _getAllLabels(of: snapshot.data!);
          _removeSelectedDeletedLabels();
          return _buildListPreviewsWidget(snapshot.data!);
        }
        if (snapshot.hasError) {
          _onListModelsLoadingError(snapshot.error!);
        }
        return Container();
      });

  Set<String> _getAllLabels({required Iterable<ListModel> of}) =>
      of.map((listModel) => listModel.labels).flattened.toSet();

  void _removeSelectedDeletedLabels() {
    selectedLabels = selectedLabels?.where(allLabels.contains);
    // if there are no labels selected, set selectedLabels to null (which signifies no 
    // filters).
    selectedLabels = (selectedLabels?.isEmpty ?? true) ? null : selectedLabels;
  }

  ListView _buildListPreviewsWidget(List<ListModel> data) => ListView(
      children: _filteredData(data)
          .map((listModel) => ListPreviewWidget(
                listModel,
                onDelete: () async {
                  await DatabaseManager.deleteListModel(listModel);
                  setState(() {});
                },
                onEdited: () => setState(() {}),
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
    setState(() {});
  }

  void _onListModelsLoadingError(Object error) {
    //TODO: handle error
    debugPrint(error.toString());
  }
}
