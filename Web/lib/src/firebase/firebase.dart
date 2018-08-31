import 'dart:html';

import 'package:Web/src/constants.dart';
import 'package:Web/src/model/note.dart';
import 'package:angular/angular.dart';
import 'package:firebase/firebase.dart' as fb;

@Injectable()
class FirebaseService {
  final fb.DatabaseReference databaseRef;
  final fb.StorageReference storageRef;
  final fb.App app;
  final List<Note> notes = [];
  bool loading = true;

  FirebaseService()
      : app = fb.app(),
        databaseRef = fb.database().ref("notes"),
        storageRef = fb.storage().ref("notes");

  init() {
    databaseRef.onChildAdded.listen((e) {
      var item = Note.fromDataSnapshot(e.snapshot);
      notes.add(item);
    });

    databaseRef.onChildRemoved.listen((e) {
      fb.DataSnapshot data = e.snapshot;
      var val = data.val();

      // Removes also the image from storage.
      var imageUrl = val[IMG_URL];
      if (imageUrl != null) {
        removeItemImage(imageUrl);
      }
      notes.removeWhere((n) => n.key == data.key);
    });

    // Sets loading to true when path changes
    databaseRef.onValue.listen((e) {
      loading = false;
    });
  }

  // Pushes a new item as a Map to database.
  postItem(Note item) async {
    try {
      await databaseRef.push(Note.toMap(item)).future;
    } catch (e) {
      print("Error in writing to database: $e");
    }
  }

  // Removes item with a key from database.
  removeItem(String key) async {
    try {
      await databaseRef.child(key).remove();
    } catch (e) {
      print("Error in deleting $key: $e");
    }
  }

  // Puts image into a storage.
  postItemImage(File file) async {
    try {
      var task = storageRef.child(file.name).put(file);
      task.onStateChanged
          .listen((_) => loading = true, onDone: () => loading = false);

      var snapshot = await task.future;
      Uri uri = await snapshot.ref.getDownloadURL();
      return uri;
    } catch (e) {
      print("Error in uploading to storage: $e");
    }
  }

  // Removes image with an imageUrl from the storage.
  removeItemImage(String imageUrl) async {
    try {
      var imageRef = fb.storage().refFromURL(imageUrl);
      await imageRef.delete();
    } catch (e) {
      print("Error in deleting $imageUrl: $e");
    }
  }
}
