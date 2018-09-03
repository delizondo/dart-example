import 'package:flutter_notes/model/note.dart';
import 'package:flutter_notes/model/notes_observable.dart';

class NotesCache {
  static final NotesCache _singleton = new NotesCache._internal();

  factory NotesCache() {
    return _singleton;
  }

  NotesCache._internal();

  final NotesObservable _observable = new NotesObservable(new List());

  NotesObservable get observable => _observable;

  add(Note note) {
    observable.add(note);
  }

  removeWhere(String key) {
    observable.removeWhere(key);
  }

  List<Note> get notes => _observable.value;
}
