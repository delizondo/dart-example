import 'package:angular/angular.dart';
import 'package:Web/app_component.template.dart' as ng;
import 'package:firebase/firebase.dart';

void main() {


  initializeApp(
      projectId: "dart-notes",
      apiKey: "AIzaSyA18vq-s5bhfvo6YBoTtry50ZM9vTn0_QQ",
      authDomain: "dart-notes.firebaseapp.com",
      databaseURL: "https://dart-notes.firebaseio.com",
      storageBucket: "dart-notes.appspot.com");

  runApp(ng.AppComponentNgFactory);
}
