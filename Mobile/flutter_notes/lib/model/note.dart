import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_notes/constants.dart';

class Note {
  String key;
  String text;
  String title;
  String imageUrl;

  Note({this.text, this.title, this.imageUrl, this.key});

  static Map toMap(Note item) {
    Map<String, dynamic> map = {
      TEXT: item.text,
      TITLE: item.title,
      IMG_URL: item.imageUrl
    };
    return map;
  }

  static Note fromDataSnapshot(DataSnapshot snapshot) {
    return new Note(
        text: snapshot.value[TEXT],
        title: snapshot.value[TITLE],
        imageUrl: snapshot.value[IMG_URL],
        key: snapshot.key);
  }
}
