import 'package:flutter/material.dart';
import 'package:movierecommender/models/diary_entry.dart';
import 'package:intl/intl.dart';

class DiaryEntryCard extends StatelessWidget {
  final DiaryEntry entry;
  final VoidCallback onTap;

  DiaryEntryCard({required this.entry, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat('MMM d, y').format(entry.date),
                style: Theme.of(context).textTheme.caption,
              ),
              SizedBox(height: 8),
              Text(
                entry.content,
                style: Theme.of(context).textTheme.bodyText2,
                maxLines: null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}