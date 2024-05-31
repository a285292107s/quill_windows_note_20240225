import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'note_provider.dart';
import 'note.dart';

class EditOrAddNotePage extends StatelessWidget {
  final Note? note;
  final int? noteIndex;

  EditOrAddNotePage({this.note, this.noteIndex});

  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (note != null) {
      titleController.text = note!.title;
      contentController.text = note!.content;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(note == null ? 'Add Note' : 'Edit Note'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 20),
          TextField(
            controller: titleController,
          ),
          SizedBox(height: 16),
          // 确保Expanded包装器正确包裹TextField
          TextField(
            controller: contentController,
            maxLines: null, // 允许多行输入
          ),
          SizedBox(height: 20),
          Align(
            alignment: Alignment.bottomRight,
            child: ElevatedButton(
              onPressed: () {
                final title = titleController.text;
                final content = contentController.text;

                if (title.isNotEmpty && content.isNotEmpty) {
                  if (note == null) {
                    Provider.of<NoteProvider>(context, listen: false)
                        .addNote(Note(title: title, content: content));
                  } else {
                    Provider.of<NoteProvider>(context, listen: false)
                        .updateNoteAt(noteIndex!, Note(title: title, content: content));
                  }

                  Navigator.pop(context);
                }
              },
              child: Text(note == null ? 'Add' : 'Save'),
            ),
          ),
        ],
      ),
    );
  }
}