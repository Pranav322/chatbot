import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:movierecommender/models/diary_entry.dart';
import 'package:movierecommender/screens/add_diary_entry_screen.dart';
import 'package:movierecommender/services/diary_service.dart';
import 'package:movierecommender/widgets/diary_entry_card.dart';
import 'package:movierecommender/widgets/floating_chatbot.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DiaryService _diaryService = DiaryService();
  List<DiaryEntry> _entries = [];

  @override
  void initState() {
    super.initState();
    _loadEntries();
  }

  void _loadEntries() async {
    final entries = await _diaryService.getEntries();
    setState(() {
      _entries = entries;
    });
  }

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Diary'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: MasonryGridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
              itemCount: _entries.length,
              itemBuilder: (context, index) {
                return DiaryEntryCard(
                  entry: _entries[index],
                  onTap: () => _showEntryDetails(_entries[index]),
                );
              },
            ),
          ),
          Positioned(
            bottom: 80,
            right: 16,
            child: FloatingActionButton(
              heroTag: 'add_entry',
              child: Icon(Icons.add),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddDiaryEntryScreen()),
                );
                _loadEntries();
              },
            ),
          ),
          FloatingChatbot(),
        ],
      ),
    );
  }
  void _showEntryDetails(DiaryEntry entry) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(DateFormat('MMMM d, y').format(entry.date)),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(entry.content),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      child: Text('Edit'),
                      onPressed: () async {
                        final updatedEntry = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddDiaryEntryScreen(entryToEdit: entry),
                          ),
                        );
                        if (updatedEntry != null) {
                          await _diaryService.updateEntry(updatedEntry);
                          _loadEntries();
                          Navigator.pop(context);
                        }
                      },
                    ),
                    ElevatedButton(
                      child: Text('Delete'),
                      onPressed: () async {
                        bool confirmDelete = await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Confirm Delete'),
                              content: Text('Are you sure you want to delete this entry?'),
                              actions: [
                                TextButton(
                                  child: Text('Cancel'),
                                  onPressed: () => Navigator.of(context).pop(false),
                                ),
                                TextButton(
                                  child: Text('Delete'),
                                  onPressed: () => Navigator.of(context).pop(true),
                                ),
                              ],
                            );
                          },
                        );

                        if (confirmDelete == true) {
                          await _diaryService.deleteEntry(entry.id);
                          _loadEntries();
                          Navigator.pop(context);
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}