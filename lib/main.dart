import 'package:flutter/material.dart';
import 'package:flutter_map_app/views/home_page.dart';
import 'package:flutter_map_app/views/maps_demo.dart';

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
      home: HomeView(),
    );
  }
}
