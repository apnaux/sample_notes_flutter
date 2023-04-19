import 'package:flutter/material.dart';
import 'package:sqlite_filehandling/db/db_helper.dart';
import 'package:sqlite_filehandling/db/note_class.dart';

class CreateNote extends StatefulWidget {
  const CreateNote({Key? key}) : super(key: key);

  @override
  State<CreateNote> createState() => _CreateNoteState();
}

class _CreateNoteState extends State<CreateNote> {
  @override
  Widget build(BuildContext context) {
    Note note = Note(id: 0, title: '', note: '', imgLoc: '');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create a New Note'),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
        actions: [
          InkWell(
            onTap: () async {
              List<Note> checkLength = await DBHelper.getNoteList();
              note.id = checkLength.length + 1;

              Map<String, dynamic> status = await DBHelper.insertNote(note);
              // Don't want the user to go back - EVER - emptying completely the navigator stack with:
              // https://stackoverflow.com/questions/44978216/flutter-remove-back-button-on-appbar
              // Navigator.of(context).pushNamedAndRemoveUntil('/mainscreen', (route) => false);

              // OR

              // RETURN A RESULT THAT WILL TRIGGER AN UPDATE FUNCTION
              // https://docs.flutter.dev/cookbook/navigation/returning-data#1-define-the-home-screen
              if (mounted) Navigator.of(context).pop(status);
            },
            child: const Icon(
              Icons.save,
            ),
          )
        ],
      ),
      body: Column(
        children: [
          TextField(
            onChanged: (value) {
              note.title = value;
            },
            decoration: const InputDecoration(
              hintText: 'Enter Title',
            ),
          ),
          TextField(
            onChanged: (value) {
              note.note = value;
            },
            decoration: const InputDecoration(
              hintText: 'Enter Note',
            ),
          ),
        ],
      ),
    );
  }
}
