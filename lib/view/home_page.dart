import 'package:flutter/material.dart';
import 'package:lists/model/list_model.dart';
import 'package:lists/model/database_manager.dart';
import 'package:lists/view/edit_dialog.dart';
import 'package:lists/view/list_widget.dart';
import 'package:lists/view/list_preview_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Lists")),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddNewListDialog,
        tooltip: 'Create a new list',
        child: const Icon(Icons.add),
      ),
    );
  }

  ListView _buildBody() {
    return ListView(
      children: DatabaseManager.listModels
          .map((listModel) => ListPreviewWidget(
                listModel,
                onDelete: () async {
                  await DatabaseManager.deleteListModel(listModel);
                  setState(() {});
                },
              ))
          .toList(),
    );
  }

  void _showAddNewListDialog() {
    showDialog(
      context: context,
      builder: (context) => SubmitValueDialog(
          title: "Enter New List Title", onSubmit: _submitNewList),
    );
  }

  void _submitNewList(String newListName) async {
    final newListModel =
        await DatabaseManager.putListModel(ListModel.fromTitle(newListName));
    if (context.mounted) {
      await Navigator.push(
          context, MaterialPageRoute(builder: (_) => ListWidget(newListModel)));
    }
    setState(() {});
  }
}
