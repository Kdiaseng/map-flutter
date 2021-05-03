import 'package:flutter/material.dart';

class FullScreenDialog extends StatelessWidget {

  final void Function(String text) onSelected;

  const FullScreenDialog({Key key, this.onSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF6200EE),
        title: Text('Full-screen Dialog'),
      ),
      body: Center(
        child: TextButton(
          onPressed: (){
            onSelected("kaleb");
            Navigator.of(context).pop();
          },
          child: Text("selected"),
        ),
      ),
    );
  }
}