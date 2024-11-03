import 'package:to_do_list_pct/app/notes_pct/interactors/note_entity.dart';

sealed class NotesListStates {}

class Empty extends NotesListStates {}



class Loaded extends NotesListStates {
  final List<Note> notesList;

  Loaded({required this.notesList});
}

class Error extends NotesListStates {
  final String message;

  Error({required this.message});
}
