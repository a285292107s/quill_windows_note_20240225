import 'package:flutter/material.dart';
import 'note.dart';

class NoteProvider with ChangeNotifier {
  List<Note> _notes = [];
  List<Note> _filteredNotes = [];

  List<Note> get notes => _filteredNotes.isNotEmpty ? _filteredNotes : _notes;

  void addNote(Note note) {
    _notes.add(note);
    notifyListeners();
  }

  void updateNoteAt(int index, Note updatedNote) {
    _notes[index] = updatedNote;
    notifyListeners();
  }

  void removeNoteAt(int index) {
    _notes.removeAt(index);
    notifyListeners();
  }

  void searchNotes(String query) {
    if (query.isNotEmpty) {
      _filteredNotes = _notes
          .where((note) =>
              note.title.toLowerCase().contains(query.toLowerCase()) ||
              note.content.toLowerCase().contains(query.toLowerCase()))
          .toList();
    } else {
      _filteredNotes = [];
    }
    notifyListeners();
  }
}
