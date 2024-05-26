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
        backgroundColor: Colors.blueGrey[900],
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blueGrey[100]!,
              Colors.blueGrey[50]!,
            ],
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              note == null ? 'Add a new note' : 'Edit your note',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey[900],
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                labelStyle: TextStyle(color: Colors.blueGrey[900]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueGrey[900]!),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              // 使用 Expanded 扩展内容区域
              child: TextField(
                controller: contentController,
                maxLines: null,
                decoration: InputDecoration(
                  labelText: 'Content',
                  labelStyle: TextStyle(color: Colors.blueGrey[900]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueGrey[900]!),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Align(
              // 使用 Align 将按钮放置在右下角
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                onPressed: () {
                  final title = titleController.text;
                  final content = contentController.text;

                  if (title.isNotEmpty && content.isNotEmpty) {
                    if (note == null) {
                      final newNote = Note(
                        title: title,
                        content: content,
                      );
                      Provider.of<NoteProvider>(context, listen: false)
                          .addNote(newNote);
                    } else {
                      final updatedNote = Note(
                        title: title,
                        content: content,
                      );
                      Provider.of<NoteProvider>(context, listen: false)
                          .updateNoteAt(noteIndex!, updatedNote);
                    }

                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey[900],
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                  textStyle: TextStyle(fontSize: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(note == null ? 'Add' : 'Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
