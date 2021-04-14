import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:game_of_fifteen/screens/home_page.dart';
import 'package:game_of_fifteen/providers/data_provider.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
        home: MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (BuildContext context) => DataProvider()),
            // FutureProvider(builder: (_) => StorageManager().readData()),
          ],
          child: HomePage(),
        )
    );
  }
}
