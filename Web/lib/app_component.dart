import 'package:Web/src/components/note/new_note_component.dart';
import 'package:Web/src/components/note/notes_component.dart';
import 'package:Web/src/firebase/firebase.dart';
import 'package:angular/angular.dart';

@Component(
    selector: 'my-app',
    styleUrls: ['app_component.css'],
    templateUrl: 'app_component.html',
    directives: const [coreDirectives, NotesComponent, NewNoteComponent],
    providers: const [
      const ClassProvider(FirebaseService),
    ])
class AppComponent implements OnInit {
  final FirebaseService service;

  AppComponent(this.service);

  @override
  void ngOnInit() {
    service.init();
  }
}
