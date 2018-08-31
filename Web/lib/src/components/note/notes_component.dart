import 'package:Web/src/firebase/firebase.dart';
import 'package:Web/src/model/note.dart';
import 'package:angular/angular.dart';

@Component(
    selector: 'notes',
    templateUrl: 'notes_component.html',
    directives: const [coreDirectives])
class NotesComponent implements OnInit {
  final FirebaseService service;
  List<Note> notes = [];

  NotesComponent(this.service);

  @override
  void ngOnInit() {
    notes = service.notes;
  }
}
