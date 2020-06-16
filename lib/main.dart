import 'package:flutter/material.dart';
import 'package:inote/note/Notes.dart';

void main() {
  runApp(NoteApp());
}

class NoteApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Mali',
          primarySwatch: Colors.green,
          canvasColor: Colors.lightGreen.shade100,
        ),
        home: Note());
  }
}
