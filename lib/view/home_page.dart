import 'package:flutter/material.dart';
import 'package:lists/model/list_model.dart';
import 'package:lists/model/database_manager.dart';
import 'package:lists/view/list_widget.dart';

class HomePage extends StatefulWidget {
  // final List<ListModel> listModels;
  const HomePage({
    super.key,
    // required this.listModels,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _editingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lists"),
      ),
      body: _buildBody(context),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddNewListDialog,
        tooltip: 'Create a new list',
        child: const Icon(Icons.add),
      ),
    );
  }

  ListView _buildBody(BuildContext context) {
    return ListView(
      children: DatabaseManager.listModels
          .map((listModel) => ListTile(
                leading: const Icon(Icons.list),
                isThreeLine: true,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) {
                    listModel.ensureMutable();
                    return ListWidget(listModel);
                  }),
                ),
                onLongPress: () => _showOptionsModalSheet(listModel),
                title: Text(
                  listModel.title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                subtitle: Text(
                  'Items: ${listModel.items.length}',
                ),
              ))
          .toList(),
    );
  }

  void _showAddNewListDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Enter New List Title", textAlign: TextAlign.center),
        content: TextFormField(
          controller: _editingController,
          autofocus: true,
          onFieldSubmitted: (_) => _submitNewList(context: context),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => _submitNewList(context: context),
            child: const Text('Submit'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.red),
            ),
          )
        ],
      ),
    );
  }

  void _submitNewList({required BuildContext context}) async {
    final newListModel =
        await DatabaseManager.createListModel(_editingController.text);
    if (context.mounted) {
      Navigator.pop(context);
      await Navigator.push(
          context, MaterialPageRoute(builder: (_) => ListWidget(newListModel)));
    }
    setState(() {});
  }

  void _showOptionsModalSheet(ListModel listModel) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton.icon(
                onPressed: () {
                  DatabaseManager.deleteListModel(listModel);
                  setState(() {});
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.delete),
                label: const Text("Delete"),
                style: const ButtonStyle(
                    foregroundColor:
                        MaterialStatePropertyAll<Color>(Colors.red))),

          ],
        ),
      ),
    );
  }
}
