import 'package:flutter/material.dart';
import 'package:flutter_notes/view/note_widget.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Notes',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NotesWidget(),
    );
  }
}
