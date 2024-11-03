import 'dart:async';

import 'package:to_do_list_pct/app/data_base_impl.dart';
import 'package:to_do_list_pct/app/notes_pct/interactors/note_entity.dart';
import 'package:to_do_list_pct/app/notes_pct/interactors/note_states.dart';

class NotesStore {
  final DataBaseImpl db;

  NotesStore({required this.db});

  final _controller = StreamController<NotesListStates>.broadcast();

  Stream<NotesListStates> get notesStream => _controller.stream;

  Stream<List<Note>> getNotesList() async* {
    NotesListStates state = Empty();
    List<Note> list = [];
    try {
      await db.getNotesList();
      db.notesList.isNotEmpty
          ? {
              list.addAll(db.notesList),
              state = Loaded(notesList: list),
            }
          : state = Empty();
    } catch (e) {
      state = Error(message: 'Erro ao carregar as anotações.');
      _controller.add(state);
      await Future.delayed(const Duration(seconds: 3));
      state = Empty();
    }

    _controller.add(state);

    yield list;
  }

  Future<void> saveNote({required Note note}) async {
    NotesListStates state = Empty();
    List<Note> list = [];
    list.addAll(db.notesList);
    if (list.any((element) => element.id == note.id)) {
      final int index = list.indexOf(list.firstWhere(
        (element) => element.id == note.id,
      ));

      list.removeWhere((element) => element.id == note.id);
      list.insert(index, note);

      try {
        await db.saveList(noteList: list);

        state = Loaded(notesList: list);
      } catch (e) {
        state = Error(message: 'Erro ao salvar a anotação.');
        _controller.add(state);
        await Future.delayed(const Duration(seconds: 3));
        state = Loaded(notesList: list);
      }
    } else {
      try {
        list.add(note);
        await db.saveList(noteList: list);

        state = Loaded(notesList: list);
      } catch (e) {
        state = Error(message: 'Erro ao salvar a anotação.');
        _controller.add(state);
        await Future.delayed(const Duration(seconds: 3));
        state = Loaded(notesList: list);
      }
    }

    _controller.add(state);
  }

  Future<void> saveNoteList({required List<Note> noteList}) async {
    NotesListStates state = Empty();

    try {
      await db.saveList(noteList: noteList);

      state = Loaded(notesList: noteList);
    } catch (e) {
      state = Error(message: 'Erro ao salvar a anotação.');
      _controller.add(state);
      await Future.delayed(const Duration(seconds: 3));
      state = Loaded(notesList: noteList);
    }

    _controller.add(state);
  }

  Future<void> deleteNote({required Note note}) async {
    NotesListStates state = Empty();
    List<Note> list = [];
    list.addAll(db.notesList);
    try {
      list.remove(note);
      await db.saveList(noteList: list);
      state = Loaded(notesList: list);
    } catch (e) {
      state = Error(message: 'Erro ao remover a anotação.');
      _controller.sink.add(state);
      await Future.delayed(const Duration(seconds: 3));
      state = Loaded(notesList: list);
    }

    _controller.sink.add(state);
  }

  void dispose() => _controller.close();
}
