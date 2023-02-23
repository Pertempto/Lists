import 'package:flutter/material.dart';
import 'package:lists/model/list_model.dart';
import 'package:lists/model/lists_database_manager.dart';
import 'package:lists/view/list_widget.dart';

void main() async {
  await DatabaseManager.init();

  final listModels = await DatabaseManager.getAllListModels();

  final listModel = listModels.isEmpty
      ? await DatabaseManager.createListModel("New list model")
      : listModels.elementAt(0);

  runApp(MyApp(listModel));
}

class MyApp extends StatelessWidget {
  final ListModel listModel;
  const MyApp(this.listModel, {super.key});

  @override
  Widget build(BuildContext context) {
    listModel.ensureMutable();

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          useMaterial3: true,
          colorScheme:
              ColorScheme.fromSeed(seedColor: const Color(0xff7f8266))),
      home: ListWidget(listModel),
    );
  }
}
