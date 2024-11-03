import 'package:flutter/material.dart';
import 'package:to_do_list_pct/app/app_colors.dart';
import 'package:to_do_list_pct/app/data_base_impl.dart';
import 'package:to_do_list_pct/app/notes_pct/interactors/note_entity.dart';
import 'package:to_do_list_pct/app/notes_pct/interactors/note_states.dart';
import 'package:to_do_list_pct/app/notes_pct/interactors/note_store.dart';
import 'package:to_do_list_pct/app/notes_pct/ui/dialogs/add_note_dialog.dart';
import 'package:to_do_list_pct/app/notes_pct/ui/notes_list_widget.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  NotesStore store = NotesStore(db: DataBaseImpl());
  List<Note> notesList = [];
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        store.getNotesList().first;
        store.notesStream.listen(
          (event) {
            if (event is Loaded) {
              notesList = event.notesList;
            }
          },
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    store.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double heigth = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: SizedBox.expand(
        child: Card(
          elevation: 15,
          child: DecoratedBox(
            decoration: BoxDecoration(gradient: MyColors().gradientHomePage()),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Center(
                    child: Card(
                        color: MyColors().paletteColor1.withOpacity(.3),
                        elevation: 20,
                        margin: const EdgeInsets.fromLTRB(1, 20, 1, 20),
                        child: SizedBox(
                          height: heigth * .06,
                          width: width,
                          child: const Text(
                            'NOTES',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 38, fontWeight: FontWeight.bold),
                          ),
                        ))),
                StreamBuilder(
                  stream: store.notesStream,
                  builder: (context, snapshot) {
                    late Widget child;
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                          child: SizedBox(child: CircularProgressIndicator()));
                    } else if (snapshot.hasError) {
                      child = const Center(
                          child: SizedBox(
                              child: Text(
                                  'Algo deu errado. Tente novamente mais tarde.')));
                    } else if (snapshot.hasData) {
                      NotesListStates? state = snapshot.data;

                      if (state is Empty) {
                        child = Container();
                      }
                      if (state is Error) {
                        child =
                            Center(child: SizedBox(child: Text(state.message)));
                      }

                      if (state is Loaded) {
                        child = SizedBox(
                            height: MediaQuery.of(context).size.height * .7,
                            width: MediaQuery.of(context).size.width * .9,
                            child: NotesListWidget(
                              list: state.notesList,
                              store: store,
                            ));
                      }
                    }
                    return child;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: FloatingActionButton(
                    onPressed: () async {
                      await addNoteDialog(context, store);
                    },
                    backgroundColor: MyColors().paletteColor2,
                    elevation: 20,
                    foregroundColor: MyColors().paletteColor1,
                    child: const Icon(Icons.add),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ReorderableListView notesListWidget({required List<Note> notesList}) {
  //   return ReorderableListView.builder(
  //       itemCount: notesList.length,
  //       onReorder: ((oldIndex, newIndex) {
  //         setState(() {
  //           if (oldIndex < newIndex) {
  //             newIndex -= 1;
  //           }
  //           final item = notesList.removeAt(oldIndex);
  //           notesList.insert(newIndex, item);
  //         });
  //         store.saveNoteList(noteList: notesList);
  //       }),
  //       itemBuilder: (BuildContext context, index) {
  //         return Slidable(
  //           key: Key('$index'),
  //           startActionPane: ActionPane(
  //             motion: const DrawerMotion(),
  //             closeThreshold: 0.1,
  //             openThreshold: 0.1,
  //             children: [
  //               SlidableAction(
  //                 onPressed: (context) async {
  //                   await store.deleteNote(note: notesList[index]);
  //                 },
  //                 backgroundColor: const Color(0xFFFE4A49),
  //                 foregroundColor: Colors.white,
  //                 icon: Icons.delete,
  //                 label: 'Delete',
  //                 borderRadius: BorderRadius.circular(15),
  //                 padding: const EdgeInsets.all(8),
  //               ),
  //               SlidableAction(
  //                 onPressed: (context) async {
  //                   await editNoteDialog(
  //                       context: context, note: notesList[index], store: store);
  //                 },
  //                 backgroundColor: const Color(0xFF21B7CA),
  //                 foregroundColor: Colors.white,
  //                 icon: Icons.edit,
  //                 label: 'Edit',
  //                 borderRadius: BorderRadius.circular(15),
  //                 padding: const EdgeInsets.all(8),
  //               ),
  //             ],
  //           ),
  //           child: Card(
  //             key: Key('$index'),
  //             shape: OutlineInputBorder(
  //                 borderSide: BorderSide(
  //                     width: notesList[index].check ? 4 : 2,
  //                     color: notesList[index].check
  //                         ? MyColors().paletteColor1
  //                         : MyColors().titleColor),
  //                 borderRadius: BorderRadius.circular(12)),
  //             color: notesList[index].check
  //                 ? const Color.fromARGB(255, 65, 126, 224)
  //                 : const Color.fromARGB(255, 14, 35, 104),
  //             child: CheckboxListTile(
  //               value: notesList[index].check,
  //               onChanged: (v) async {
  //                 Note editedNote = Note.copyWith(
  //                     id: notesList[index].id,
  //                     title: notesList[index].title,
  //                     description: notesList[index].description,
  //                     check: !notesList[index].check);
  //                 await store.saveNote(note: editedNote);
  //               },
  //               title: Text(notesList[index].title,
  //                   style: TextStyle(
  //                       fontWeight: FontWeight.bold,
  //                       color: notesList[index].check
  //                           ? Colors.black
  //                           : MyColors().titleColor)),
  //               subtitle: Text(notesList[index].description ?? '',
  //                   style: TextStyle(
  //                       color: notesList[index].check
  //                           ? Colors.black
  //                           : MyColors().titleColor)),
  //             ),
  //           ),
  //         );
  //       });
  // }
}
