import 'package:flutter/material.dart';
import 'package:flutter_map_app/views/add_entry_dialog.dart';
import 'package:flutter_map_app/views/dialog.dart';
import 'package:flutter_map_app/views/splash.dart';
import 'package:flutter_map_app/views/teste_card_parking.dart';

import 'views/home_view.dart';

void main() {
  runApp(AppWidget());
}

class AppWidget extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: MyHomePage());
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FlatButton(
          textColor: Color(0xFF6200EE),
          highlightColor: Colors.transparent,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (BuildContext context) => FullScreenDialog(
                  onSelected:(text) => print(text),
                ),
                fullscreenDialog: true,
              ),
            );
          },
          child: Text("SHOW DIALOG"),
        ),
      ),
    );
  }
}
