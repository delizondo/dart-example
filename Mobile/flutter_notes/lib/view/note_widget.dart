import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_notes/firebase/firebase.dart';
import 'package:flutter_notes/model/note.dart';
import 'package:flutter_notes/model/notes_cache.dart';
import 'package:flutter_notes/view/new_note_widget.dart';

class NotesWidget extends StatefulWidget {
  @override
  _NotesWidgetState createState() => _NotesWidgetState();
}

class _NotesWidgetState extends State<NotesWidget> {
  FirebaseService service;
  List<Note> notes = [];
  final NotesCache notesCache = new NotesCache();

  @override
  void initState() {
    super.initState();
    service = FirebaseService();
    notesCache.observable.addListener(() {
      setState(() {
        notes = notesCache.notes;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Notes"),
      ),
      body: Container(
        color: Colors.grey[100],
        child: ListView.builder(
            itemCount: notes.length,
            itemBuilder: (BuildContext context, int index) {
              return _getNotes(notes[index]);
            }),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _addNewNote,
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _getNotes(Note note) {
    return new Card(
      color: Colors.white,
      elevation: 2.0,
      child: new Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Text(
              note.title,
              textScaleFactor: 1.5,
              style: TextStyle(color: Colors.grey[400]),
            ),
            Text(note.text),
            new Container(
              child: (note.imageUrl == null || note.imageUrl.isEmpty)
                  ? null
                  : new Image(
                      image: (note.imageUrl == null || note.imageUrl.isEmpty)
                          ? null
                          : new CachedNetworkImageProvider(note.imageUrl)),
            )
          ],
        ),
      ),
    );
  }

  _addNewNote() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NewNoteWidget()),
    );
  }
}
