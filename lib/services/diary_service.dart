import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:movierecommender/models/diary_entry.dart';

class DiaryService {
  static const String _storageKey = 'diary_entries';

  Future<List<DiaryEntry>> getEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final String? entriesJson = prefs.getString(_storageKey);
    if (entriesJson == null) return [];
    final List<dynamic> entriesList = jsonDecode(entriesJson);
    return entriesList.map((e) => DiaryEntry.fromJson(e)).toList();
  }

  Future<void> addEntry(DiaryEntry entry) async {
    final entries = await getEntries();
    entries.add(entry);
    await _saveEntries(entries);
  }

  Future<void> updateEntry(DiaryEntry updatedEntry) async {
    final entries = await getEntries();
    final index = entries.indexWhere((e) => e.id == updatedEntry.id);
    if (index != -1) {
      entries[index] = updatedEntry;
      await _saveEntries(entries);
    }
  }

  Future<void> deleteEntry(String id) async {
    final entries = await getEntries();
    entries.removeWhere((e) => e.id == id);
    await _saveEntries(entries);
  }

  Future<void> _saveEntries(List<DiaryEntry> entries) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, jsonEncode(entries.map((e) => e.toJson()).toList()));
  }
}