import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'edit_or_add_note_page.dart';
import 'inbox.dart';
import 'note_provider.dart';
import 'package:provider/provider.dart';

import 'theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  WindowOptions windowOptions = const WindowOptions(
    size: Size(900, 600),
    center: true,
    //backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.hidden,
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes App',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      home: SendNotePage(),
    );
  }
}

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  bool isMaximized = false;

  @override
  void initState() {
    super.initState();
    checkMaximizedStatus();
  }

  void checkMaximizedStatus() async {
    isMaximized = await windowManager.isMaximized();
    setState(() {});
  }

  void toggleMaximize() async {
    isMaximized ? windowManager.restore() : windowManager.maximize();
    isMaximized = !isMaximized;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
        //leading: Icon(Icons.menu),
        actions: [
          IconButton(
            icon: const Icon(Icons.minimize),
            onPressed: () {
              windowManager.minimize();
            },
          ),
          IconButton(
            //最大化和窗口化
            icon: Icon(isMaximized ? Icons.crop_square_outlined : Icons.fit_screen_outlined),
            onPressed: toggleMaximize,
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              windowManager.close();
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search notes...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
              ),
              onChanged: (query) {
                Provider.of<NoteProvider>(context, listen: false)
                    .searchNotes(query);
              },
            ),
          ),
        ),
      ),
      body: Consumer<NoteProvider>(
        builder: (context, noteProvider, child) {
          final notes = noteProvider.notes;
          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];
              return ListTile(
                title: Text(note.title),
                subtitle: Text(note.content),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditOrAddNotePage(
                        note: note,
                        noteIndex: index,
                      ),
                    ),
                  );
                },
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    noteProvider.removeNoteAt(index);
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditOrAddNotePage(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
