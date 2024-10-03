import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movierecommender/utils/constants.dart';

class ChatbotService {
  Future<String> getRecommendations(String diaryEntry) async {
    final response = await http.post(
      Uri.parse('${Constants.apiUrl}/recommend-movies'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'diaryEntry': diaryEntry}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['recommendations'];
    } else {
      throw Exception('Failed to get recommendations');
    }
  }
}