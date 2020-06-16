import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:inote/note/NotesModel.dart';
import 'package:scoped_model/scoped_model.dart';

import 'NotesDBWorker.dart';
import 'NotesModel.dart' show Note, NoteModel, noteModel;

class NoteList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModel(
        model: noteModel,
        child: ScopedModelDescendant<NoteModel>(
          builder: (BuildContext inContext, Widget inChild, NoteModel inModel) {
            return Scaffold(
                appBar: AppBar(
                  title: Text('Ma note', style: TextStyle(color: Colors.white)),
                  elevation: 0.0,
                  bottom: PreferredSize(
                      child: Container(), preferredSize: Size.fromHeight(32.0)),
                  flexibleSpace: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.green, Colors.lightGreen.shade100],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  centerTitle: true,
                  actions: [
                    IconButton(
                        icon: Icon(Icons.delete_sweep),
                        tooltip: 'vider',
                        color: Colors.red,
                        iconSize: 32.0,
                        onPressed: () {
                          _deleteNoteDialog(inContext);
                          print('delete all notes....');
                        })
                  ],
                ),
                floatingActionButton: FloatingActionButton(
                  backgroundColor: Colors.green,
                  onPressed: () {
                    noteModel.entityBeingEdited = Note();
                    noteModel.setColor(null);
                    noteModel
                        .setStackIndex(1); //index 1 renvoie la page d'édition
                  },
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
                body: ListView.builder(
                    itemCount: noteModel.entityList.length,
                    itemBuilder: (BuildContext inBuildContext, int inInDex) {
                      Note note = noteModel.entityList[inInDex];
                      Color color = Colors.greenAccent;

                      switch (note.color) {
                        case "blue":
                          color = Colors.blue;
                          break;
                        case "green":
                          color = Colors.green;
                          break;
                        case "purple":
                          color = Colors.purple;
                          break;
                        case "grey":
                          color = Colors.grey;
                          break;
                        case "amber":
                          color = Colors.amber;
                          break;
                        case "red":
                          color = Colors.red;
                          break;
                      }

                      return Container(
                        padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                        child: Slidable(
                            actionExtentRatio: .30,
                            secondaryActions: <Widget>[
                              IconSlideAction(
                                caption: "Supprimer",
                                color: Colors.red,
                                icon: Icons.delete,
                                onTap: () {
                                  _deleteNoteDialog(inContext, note: note);
                                },
                              ),
                              IconSlideAction(
                                  caption: "Editer",
                                  color: Colors.green,
                                  icon: Icons.update,
                                  onTap: () async {
/*Ici, on n'a pas besoin de se fatiguer; on attribut juste le valeurs de la ta
                                  * à la valiable entityBeingEdited dans le modèle NoteModel.
                                  * Tout est dès lors présent dans les champs d'édition*/
                                    noteModel.entityBeingEdited =
                                        await NoteDBWorker.db.getNote(note.id);
                                    noteModel.setStackIndex(1);
                                  }),
                            ],
                            child: Card(
                                //@TODO
                                //Besoin d'un stack index pour aggrandir la note.
                                //DEMAIN SERA MEILLEUR .
                                color: color,
                                elevation: 8,
                                child: ExpansionTile(
                                  title: Text(
                                    "${note.title}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: "Mali",
                                        fontSize: 18,
                                        color: Colors.black54,
                                        backgroundColor: Colors.black12),
                                  ),
                                  children: <Widget>[
                                    Text(
                                      "${note.content}",
                                      style: TextStyle(
                                        fontFamily: "Mali",
                                        fontSize: 24,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    )
                                  ],
                                )),
                            actionPane: SlidableDrawerActionPane()),
                      );
                    }));
          },
        ));
  }

  /// purge notes
  Future _deleteNoteDialog(BuildContext inContext, {Note note}) async {
    return await showDialog(
      context: inContext,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.lightGreen.shade100,
          elevation: 3,
          title: note == null
              ? Text("Vider la liste")
              : Text("supprimer ${note.title}"),
          content: note == null
              ? Text("Etes-vous conscient de bien vouloir tout supprimer?")
              : Text(
                  "Etes-vous conscient de bien vouloir supprimer cette note ?"),
          actions: <Widget>[
            FlatButton(
              child: Text('ANNULER'),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
            FlatButton(
              child: Text(
                'SUPPRIMER',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () async {
                if (note != null) {
                  await NoteDBWorker.db.deleteNote(note.id);
                } else {
                  await NoteDBWorker.db.deleteAll();
                }
                noteModel.loadData("notes", NoteDBWorker.db);

                Navigator.of(inContext).pop();
                Scaffold.of(inContext).showSnackBar(SnackBar(
                  content: Text("Note supprimée avec succès."),
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 2),
                ));
              },
            ),
          ],
        );
      },
    );
  }

  /// delete note by id
  Future _deleteNoteIDDialog(BuildContext inContext, Note note) async {
    return await showDialog(
      context: inContext,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Vider la liste"),
          content: Text("Etes-vous conscient de bien vouloir tout supprimer?"),
          actions: <Widget>[
            FlatButton(
              child: Text('ANNULER'),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
            FlatButton(
              child: Text(
                'SUPPRIMER',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () async {
                await NoteDBWorker.db.deleteNote(note.id);
                Navigator.of(inContext).pop();
                Scaffold.of(inContext).showSnackBar(SnackBar(
                  content: Text("Note supprimée avec succès."),
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 2),
                ));
                noteModel.loadData("notes", NoteDBWorker.db);
              },
            ),
          ],
        );
      },
    );
  }
}
