import 'package:flutter/material.dart';
import 'package:flutter_application_1/note_card.dart';
import 'package:flutter_application_1/db_notes.dart';
import 'package:flutter_application_1/dialog.dart'; // make sure you import your NoteDialog

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes App',
      theme: ThemeData(primarySwatch: Colors.blueGrey),
      debugShowCheckedModeBanner: false,
      home: const NotesScreen(),
    );
  }
}

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  List<Map<String, dynamic>> notes = [];

  @override
  void initState() {
    super.initState();
    fetchNotes();
  }

  Future<void> fetchNotes() async {
    final fetchedNotes = await Notesdb.instance.getNotes();
    setState(() {
      notes = fetchedNotes;
    });
  }

  final List<Color> noteColors = [
    Colors.white,
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.purple,
  ];

  void showNoteDialog({
    int? noteId,
    String? title,
    String? content,
    int? color = 0,
  }) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return NoteDialog(
          noteId: noteId,
          title: title,
          content: content,
          color: color,
          noteColors: noteColors,
          onNote: (newTitle, newDesc, newColor) async {
            if (noteId != null) {
              await Notesdb.instance.updateNote(
                noteId,
                newTitle,
                newDesc,
                DateTime.now().toString(),
                newColor,
              );
            } else {
              await Notesdb.instance.addNote(
                newTitle,
                newDesc,
                DateTime.now().toString(),
                newColor,
              );
            }
            fetchNotes();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notes',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showNoteDialog(),
        backgroundColor: Colors.white,
        child: const Icon(Icons.add, color: Colors.black87),
      ),
      body: notes.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notes_outlined, size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 20),
                  Text(
                    'No Notes',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.8,
                ),
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  final note = notes[index];
                  return NotesCard(
                    note: note,
                    noteColors: noteColors,
                    delete: (id) async {
                      await Notesdb.instance.deleteNote(id);
                      fetchNotes();
                    },
                    onTap: () {
                      showNoteDialog(
                        noteId: note['id'],
                        title: note['title'],
                        content: note['content'],
                        color: note['color'],
                      );
                    },
                  );
                },
              ),
            ),
    );
  }
}
