import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'NotesDBWorker.dart';
import 'NotesEntry.dart';
import 'NotesList.dart';
import 'NotesModel.dart' show NoteModel, noteModel;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../Utils.dart' as utils;

class Note extends StatelessWidget {
  Note() {
    getPath();
    noteModel.loadData("notes", NoteDBWorker.db);
  }

  getPath() async {
    Directory docsDir = await getApplicationDocumentsDirectory();
    utils.docsDir = docsDir;
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel(
        model: noteModel,
        child: ScopedModelDescendant<NoteModel>(
          builder: (BuildContext inContext, Widget inChild, NoteModel inModel) {
            return IndexedStack(
              index: inModel.stackIndex,
              children: <Widget>[NoteList(), NoteEntry()],
            );
          },
        ));
  }
}
