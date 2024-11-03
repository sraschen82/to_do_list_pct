import 'package:flutter/material.dart';
import 'package:to_do_list_pct/app/notes_pct/interactors/note_entity.dart';
import 'package:to_do_list_pct/app/notes_pct/interactors/note_store.dart';
import 'package:to_do_list_pct/app/app_colors.dart';

Future<void> addNoteDialog(BuildContext context, NotesStore store) async {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  return showDialog(
      context: context,
      builder: (context) {
        validateForm() async {
          if (titleController.text.isNotEmpty) {
            Note newNote = Note.copyWith(
                id: DateTime.now().microsecondsSinceEpoch,
                title: titleController.text,
                description: descriptionController.text,
                check: false);
            await store.saveNote(note: newNote);

            Navigator.pop(context);
          }
        }

        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 3, 5, 109),
          shape: OutlineInputBorder(
            borderSide: BorderSide(color: MyColors().titleColor),
            borderRadius: BorderRadius.circular(12),
          ),
          titleTextStyle: const TextStyle(fontWeight: FontWeight.bold),
          title: const Center(
              child: Text(
            'ADD NOTE',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
          )),
          content: SingleChildScrollView(
            child: Column(
              children: [
                Card(
                  color: const Color.fromARGB(255, 3, 5, 109),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      maxLength: 30,
                      cursorColor: MyColors().titleColor,
                      cursorRadius: const Radius.circular(15),
                      cursorHeight: 18,
                      showCursor: true,
                      controller: titleController,
                      style: TextStyle(color: MyColors().titleColor),
                      decoration: InputDecoration(
                          alignLabelWithHint: true,
                          labelText: 'Title',
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: MyColors().titleColor,
                              ),
                              borderRadius: BorderRadius.circular(12)),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: MyColors().titleColor,
                              ),
                              borderRadius: BorderRadius.circular(12)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: MyColors().titleColor,
                              ),
                              borderRadius: BorderRadius.circular(12)),
                          fillColor: MyColors().titleColor,
                          floatingLabelStyle: TextStyle(
                            color: MyColors().titleColor,
                          )),
                      autofocus: true,
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                ),
                Card(
                  color: const Color.fromARGB(255, 3, 5, 109),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      cursorColor: MyColors().titleColor,
                      cursorRadius: const Radius.circular(15),
                      cursorHeight: 18,
                      maxLines: 5,
                      maxLength: 300,
                      showCursor: true,
                      controller: descriptionController,
                      style: TextStyle(color: MyColors().titleColor),
                      decoration: InputDecoration(
                          alignLabelWithHint: true,
                          labelText: 'Description',
                          fillColor: MyColors().titleColor,
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: MyColors().titleColor,
                              ),
                              borderRadius: BorderRadius.circular(12)),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: MyColors().titleColor,
                              ),
                              borderRadius: BorderRadius.circular(12)),
                          focusColor: MyColors().titleColor,
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: MyColors().titleColor,
                              ),
                              borderRadius: BorderRadius.circular(12)),
                          floatingLabelStyle: TextStyle(
                            color: MyColors().titleColor,
                          )),
                      autofocus: true,
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel')),
            TextButton(
              onPressed: () => validateForm(),
              child: const Text('Save'),
            ),
          ],
        );
      });
}
