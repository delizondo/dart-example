import 'dart:html';

import 'package:Web/src/firebase/firebase.dart';
import 'package:Web/src/model/note.dart';
import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';

@Component(
    selector: 'new-note',
    templateUrl: 'new_note_component.html',
    directives: const [coreDirectives, formDirectives])
class NewNoteComponent {
  final FirebaseService service;
  Note note = new Note();
  bool fileDisabled = false;

  NewNoteComponent(this.service);

  @ViewChild("submit")
  ElementRef submitButton;

  uploadImage(e) async {
    fileDisabled = true;
    var file = (e.target as FileUploadInputElement).files[0];
    var image = await service.postItemImage(file);

    note.imageUrl = image.toString();
  }

  removeImage() {
    service.removeItemImage(note.imageUrl);

    note.imageUrl = null;
    fileDisabled = false;
  }

  submitForm() {
    service.postItem(note);

    submitButton.nativeElement.blur();
    note = new Note();
    fileDisabled = false;
  }
}
