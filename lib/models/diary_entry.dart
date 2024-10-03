class DiaryEntry {
  final String id;
  final String content;
  final DateTime date;

  DiaryEntry({required this.id, required this.content, required this.date});

  factory DiaryEntry.fromJson(Map<String, dynamic> json) {
    return DiaryEntry(
      id: json['id'],
      content: json['content'],
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'date': date.toIso8601String(),
    };
  }
}