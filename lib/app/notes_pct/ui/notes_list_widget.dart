import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:to_do_list_pct/app/app_colors.dart';
import 'package:to_do_list_pct/app/notes_pct/interactors/note_entity.dart';
import 'package:to_do_list_pct/app/notes_pct/interactors/note_store.dart';
import 'package:to_do_list_pct/app/notes_pct/ui/dialogs/edit_note_dialog.dart';

class NotesListWidget extends StatefulWidget {
  final List<Note> list;
  final NotesStore store;
  const NotesListWidget({super.key, required this.list, required this.store});

  @override
  State<NotesListWidget> createState() => _NotesListWidgetState();
}

class _NotesListWidgetState extends State<NotesListWidget> {
 

  @override
  Widget build(BuildContext context) {
     List<Note> notesList = widget.list;
     NotesStore store = widget.store;
  
    return ReorderableListView.builder(
        itemCount: notesList.length,
        onReorder: ((oldIndex, newIndex) {
          setState(() {
            if (oldIndex < newIndex) {
              newIndex -= 1;
            }
            final item = notesList.removeAt(oldIndex);
            notesList.insert(newIndex, item);
          });
          store.saveNoteList(noteList: notesList);
        }),
        itemBuilder: (BuildContext context, index) {
          return Slidable(
            key: Key('$index'),
            startActionPane: ActionPane(
              motion: const DrawerMotion(),
              closeThreshold: 0.1,
              openThreshold: 0.1,
              children: [
                SlidableAction(
                  onPressed: (context) async {
                    await store.deleteNote(note: notesList[index]);
                  },
                  backgroundColor: const Color(0xFFFE4A49),
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: 'Delete',
                  borderRadius: BorderRadius.circular(15),
                  padding: const EdgeInsets.all(8),
                ),
                SlidableAction(
                  onPressed: (context) async {
                    await editNoteDialog(
                        context: context, note: notesList[index], store: store);
                  },
                  backgroundColor: const Color(0xFF21B7CA),
                  foregroundColor: Colors.white,
                  icon: Icons.edit,
                  label: 'Edit',
                  borderRadius: BorderRadius.circular(15),
                  padding: const EdgeInsets.all(8),
                ),
              ],
            ),
            child: Card(
              key: Key('$index'),
              shape: OutlineInputBorder(
                  borderSide: BorderSide(
                      width: notesList[index].check ? 4 : 2,
                      color: notesList[index].check
                          ? MyColors().paletteColor1
                          : MyColors().titleColor),
                  borderRadius: BorderRadius.circular(12)),
              color: notesList[index].check
                  ? const Color.fromARGB(255, 65, 126, 224)
                  : const Color.fromARGB(255, 14, 35, 104),
              child: CheckboxListTile(
                value: notesList[index].check,
                onChanged: (v) async {
                  Note editedNote = Note.copyWith(
                      id: notesList[index].id,
                      title: notesList[index].title,
                      description: notesList[index].description,
                      check: !notesList[index].check);
                  await store.saveNote(note: editedNote);
                },
                title: Text(notesList[index].title,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: notesList[index].check
                            ? Colors.black
                            : MyColors().titleColor)),
                subtitle: Text(notesList[index].description ?? '',
                    style: TextStyle(
                        color: notesList[index].check
                            ? Colors.black
                            : MyColors().titleColor)),
              ),
            ),
          );
        });
  }
  }

