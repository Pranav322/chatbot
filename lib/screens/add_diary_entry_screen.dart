import 'package:flutter/material.dart';
import 'package:movierecommender/models/diary_entry.dart';
import 'package:movierecommender/services/diary_service.dart';

class AddDiaryEntryScreen extends StatefulWidget {
  final DiaryEntry? entryToEdit;

  AddDiaryEntryScreen({this.entryToEdit});

  @override
  _AddDiaryEntryScreenState createState() => _AddDiaryEntryScreenState();
}

class _AddDiaryEntryScreenState extends State<AddDiaryEntryScreen> {
  final TextEditingController _controller = TextEditingController();
  final DiaryService _diaryService = DiaryService();

  @override
  void initState() {
    super.initState();
    if (widget.entryToEdit != null) {
      _controller.text = widget.entryToEdit!.content;
    }
  }

  void _saveEntry() async {
    if (_controller.text.isNotEmpty) {
      final entry = widget.entryToEdit != null
          ? DiaryEntry(
              id: widget.entryToEdit!.id,
              content: _controller.text,
              date: widget.entryToEdit!.date,
            )
          : DiaryEntry(
              id: DateTime.now().toString(),
              content: _controller.text,
              date: DateTime.now(),
            );

      if (widget.entryToEdit != null) {
        await _diaryService.updateEntry(entry);
      } else {
        await _diaryService.addEntry(entry);
      }

      Navigator.pop(context, entry);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.entryToEdit != null ? 'Edit Diary Entry' : 'Add Diary Entry'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: InputDecoration(
                  hintText: 'Write your diary entry here...',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              child: Text(widget.entryToEdit != null ? 'Update Entry' : 'Save Entry'),
              onPressed: _saveEntry,
            ),
          ],
        ),
      ),
    );
  }
}