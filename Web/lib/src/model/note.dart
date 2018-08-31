import 'package:Web/src/constants.dart';
import 'package:firebase/firebase.dart';

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
        text: snapshot.val()[TEXT],
        title: snapshot.val()[TITLE],
        imageUrl: snapshot.val()[IMG_URL],
        key: snapshot.key);
  }
}
