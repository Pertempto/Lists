import 'package:flutter/material.dart';
import 'package:lists/model/list_model.dart';
import 'package:lists/model/database_manager.dart';
import 'package:lists/view/home_page.dart';

void main() async {
  await DatabaseManager.init();

  // final listModels = await DatabaseManager.loadListModels();

  // final listModel = listModels.isEmpty
  //     ? await ListsDatabaseManager.createListModel("New list model")
  //     : listModels.elementAt(0);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // final List<ListModel> listModels;
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff7f8266)),
        // listTileTheme: ListTileThemeData(
        //   contentPadding: EdgeInsets.all(8),
        //   shape: RoundedRectangleBorder(
        //       borderRadius: BorderRadius.circular(8.0)),
      ),
      home: HomePage(),
    );
  }
}
