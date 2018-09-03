import 'package:flutter/foundation.dart';
import 'package:flutter_notes/model/note.dart';

class NotesObservable extends ValueNotifier<List<Note>> {
  NotesObservable(List<Note> value) : super(value);

  add(Note note) {
    value.insert(0, note);
    notifyListeners();
  }

  create(List<Note> list) {
    value = list;
    notifyListeners();
  }

  delete(int index) {
    value.removeAt(index);
    notifyListeners();
  }

  removeWhere(String key) {
    value.removeWhere((n) => n.key == key);
    notifyListeners();
  }
}
