// ignore_for_file: prefer_final_fields

import 'package:to_do_list_pct/app/notes_pct/interactors/note_entity.dart';

class DataBaseImpl {
  DataBaseImpl() {}

  List<Note> _notesList = [];

  List<Note> get notesList => _notesList;

  Future<void> getNotesList() async {
    // await Future.delayed(const Duration(seconds: 1));
    final todo1 = Note(
        id: 0,
        title: '320 - Av Trimestral 3º TRI',
        description: 'Dia 13/11/24',
        check: false);
    final todo2 = Note(
        id: 1,
        title: 'Hackathon 2024',
        description: 'Dia 30/11/24',
        check: false);

    final todo3 = Note(
        id: 2,
        title: 'Natal do Mauá',
        description: 'Dia 07/12/24',
        check: false);

    _notesList.addAll([todo1, todo2, todo3]);
    print('Lista de tarefas carregada');
  }

  Future<void> saveList({required List<Note> noteList}) async {
    // await Future.delayed(const Duration(seconds: 1));
    _notesList = noteList;
    print('Lista de tarefas salva');
  }
}
