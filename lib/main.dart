import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Заметки',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
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
  final TextEditingController _textController = TextEditingController();
  
  final List<String> _notes = [];

  int? _editingIndex;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _addNote() {
    if (_textController.text.isNotEmpty) {
      setState(() {
        _notes.add(_textController.text);
        _textController.clear();
      });
    }
  }

  void _deleteNote(int index) {
    setState(() {
      _notes.removeAt(index);
    });
  }

  void _editNote(int index) {
    setState(() {
      _editingIndex = index;
      _textController.text = _notes[index];
    });
  }

  void _updateNote() {
    if (_textController.text.isNotEmpty && _editingIndex != null) {
      setState(() {
        _notes[_editingIndex!] = _textController.text;
        _textController.clear();
        _editingIndex = null;
      });
    }
  }

  void _cancelEdit() {
    setState(() {
      _textController.clear();
      _editingIndex = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Мои заметки'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _textController,
              decoration: InputDecoration(
                hintText: 'Введите текст заметки...',
                border: const OutlineInputBorder(),
                suffixIcon: _editingIndex != null
                    ? IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: _cancelEdit,
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: _editingIndex == null ? _addNote : _updateNote,
              child: Text(_editingIndex == null ? 'Сохранить' : 'Обновить'),
            ),
            
            const SizedBox(height: 20),

            const Text(
              'Список заметок:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            
            const SizedBox(height: 10),

            Expanded(
              child: _notes.isEmpty
                  ? const Center(
                      child: Text('Нет заметок'),
                    )
                  : ListView.builder(
                      itemCount: _notes.length,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            title: Text(_notes[index]),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () => _editNote(index),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () => _deleteNote(index),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
