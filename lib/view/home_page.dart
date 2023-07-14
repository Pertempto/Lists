import 'package:flutter/material.dart';
import 'package:lists/model/list_model.dart';
import 'package:lists/model/database_manager.dart';
import 'package:lists/view/list_settings_dialog.dart';
import 'package:lists/view/list_widget.dart';
import 'package:lists/view/list_preview_widget.dart';
import 'package:lists/view/settings_widget.dart';
import 'package:modal_side_sheet/modal_side_sheet.dart';

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
  late Future<void> startupFuture = _startup();
  late List<ListModel> data;

  Future<void> _startup() async =>
      data = await DatabaseManager.loadListModels();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: const Text('Lists'), actions: [_buildSettingsButton()]),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddNewListDialog,
        tooltip: 'Create a new list',
        child: const Icon(Icons.add),
      ),
    );
  }

  IconButton _buildSettingsButton() => IconButton(
      icon: const Icon(Icons.settings),
      onPressed: () =>
          showModalSideSheet(context: context, body: const SettingsWidget()));

  Widget _buildBody() =>
      // We use the `data` only if `startupFuture` has completed (and loaded the 
      // `ListModel`s from the database into `data`).
      FutureBuilder<void>(
          future: startupFuture,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return _buildListPreviewsWidget();
            }
            if (snapshot.hasError) {
              _onListModelsLoadingError(snapshot.error!);
            }
            return Container();
          });

  ListView _buildListPreviewsWidget() => ListView(
      children: data
          .map((listModel) => ListPreviewWidget(
                listModel,
                onDelete: () async {
                  await DatabaseManager.deleteListModel(listModel);
                  setState(() => data.remove(listModel));
                },
              ))
          .toList());

  void _showAddNewListDialog() => showDialog(
        context: context,
        builder: (context) => ListSettingsDialog(
            onSubmit: _submitNewList, listModel: ListModel()),
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
