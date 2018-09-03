import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_notes/constants.dart';
import 'package:flutter_notes/model/note.dart';
import 'package:flutter_notes/model/notes_cache.dart';
import 'package:path/path.dart';

class FirebaseService {
  static final FirebaseService _singleton = new FirebaseService._internal();

  DatabaseReference databaseRef;
  StorageReference storageRef;

  factory FirebaseService() {
    return _singleton;
  }

  //bool loading = true;
  //final List<Note> notes = [];

  final NotesCache notes = new NotesCache();

  FirebaseService._internal() {
    init();
  }

  FirebaseDatabase getDataBaseInstance() {
    return FirebaseDatabase.instance;
  }

  FirebaseStorage getStorageInstnace() {
    return FirebaseStorage.instance;
  }

  init() {
    databaseRef = getDataBaseInstance().reference().child("notes");
    storageRef = getStorageInstnace().ref().child("notes");

    databaseRef.onChildAdded.listen((e) {
      var item = Note.fromDataSnapshot(e.snapshot);
      notes.add(item);
    });

    databaseRef.onChildRemoved.listen((e) {
      DataSnapshot data = e.snapshot;
      var val = data.value;

      // Removes also the image from storage.
      var imageUrl = val[IMG_URL];
      if (imageUrl != null) {
        removeItemImage(imageUrl);
      }
      //notes.removeWhere((n) => n.key == data.key);
      notes.removeWhere(data.key);
    });

    // Sets loading to true when path changes
    /*databaseRef.onValue.listen((e) {
      loading = false;
    });*/
  }

  // Pushes a new item as a Map to database.
  postItem(Note item) async {
    try {
      await databaseRef.push().set(Note.toMap(item));
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
      var task = storageRef.child(basename(file.path)).putFile(file);
      Uri uri = (await task.future).downloadUrl;
      return uri;
    } catch (e) {
      print("Error in uploading to storage: $e");
    }
  }

  // Removes image with an imageUrl from the storage.
  removeItemImage(String imageUrl) async {
    try {
      var imageRef = storageRef.child(imageUrl);
      await imageRef.delete();
    } catch (e) {
      print("Error in deleting $imageUrl: $e");
    }
  }
}
