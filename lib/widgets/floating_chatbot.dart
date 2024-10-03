import 'package:flutter/material.dart';
import 'package:movierecommender/models/diary_entry.dart';
import 'package:movierecommender/services/chatbot_service.dart';
import 'package:movierecommender/services/diary_service.dart';
import 'package:google_fonts/google_fonts.dart';

class FloatingChatbot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 16,
      right: 16,
      child: FloatingActionButton(
        heroTag: 'chatbot',
        child: Icon(Icons.chat),
        backgroundColor: Colors.deepPurple,
        onPressed: () {
          _showChatbotDialog(context);
        },
      ),
    );
  }

  void _showChatbotDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            color: Color.fromRGBO(0, 0, 0, 0.001),
            child: GestureDetector(
              onTap: () {},
              child: Container(
                height: MediaQuery.of(context).size.height * 0.8,
                decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: ChatbotContent(),
              ),
            ),
          ),
        );
      },
    );
  }
}

class ChatbotContent extends StatefulWidget {
  @override
  _ChatbotContentState createState() => _ChatbotContentState();
}

class _ChatbotContentState extends State<ChatbotContent> {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [
    ChatMessage(text: 'Hello! How can I help you today?', isBot: true)
  ];
  final ChatbotService _chatbotService = ChatbotService();
  final DiaryService _diaryService = DiaryService();
  bool _waitingForMood = false;
  bool _waitingForConfirmation = false;
  List<DiaryEntry> _entries = [];

  @override
  void initState() {
    super.initState();
    _loadEntries();
  }

  void _loadEntries() async {
    _entries = await _diaryService.getEntries();
  }

  void _handleSubmitted(String text) async {
  if (text.isEmpty) return;

  setState(() {
    _messages.add(ChatMessage(text: text, isBot: false));
  });

  if (_waitingForConfirmation) {
    _handleConfirmation(text);
  } else if (_waitingForMood) {
    _handleMoodResponse(text);
  } else {
    _handleGeneralQuery(text);
  }

  _controller.clear();
}

  bool _isAskingForRecommendation(String text) {
    return text.toLowerCase().contains('recommend') || text.toLowerCase().contains('movie');
  }

  void _askForConfirmation() {
    setState(() {
      _messages.add(ChatMessage(
        text: 'Would you like me to recommend movies based on your latest diary entry? (Yes/No)',
        isBot: true,
      ));
      _waitingForConfirmation = true;
    });
  }

  void _handleConfirmation(String response) {
    if (response.toLowerCase() == 'yes') {
      if (_entries.isNotEmpty) {
        _provideRecommendations(_entries.last.content);
      } else {
        _askForMood();
      }
    } else {
      _askForMood();
    }
    _waitingForConfirmation = false;
  }

  void _askForMood() {
    setState(() {
      _messages.add(ChatMessage(
        text: 'Could you tell me about your current mood for personalized movie suggestions?',
        isBot: true,
      ));
      _waitingForMood = true;
    });
  }

  void _handleMoodResponse(String mood) async {
    setState(() {
      _messages.add(ChatMessage(
        text: 'Thank you for sharing your mood. Let me recommend some movies based on that.',
        isBot: true,
      ));
    });
    final recommendations = await _chatbotService.getRecommendations(mood);
    setState(() {
      _messages.add(ChatMessage(
        text: 'Based on your mood, here are some movie recommendations:\n\n$recommendations',
        isBot: true,
      ));
      _waitingForMood = false;
    });
  }

  void _handleGeneralQuery(String query) async {
  if (query.toLowerCase().contains('diary')) {
    _handleDiaryQuery(query);
  } else if (query.toLowerCase().contains('recommend') || query.toLowerCase().contains('movie')) {
    _askForConfirmation();
  } else if (query.toLowerCase().contains('mood')) {
    _askForMood();
  } else {
    setState(() {
      _messages.add(ChatMessage(
        text: 'I\'m here to help with movie recommendations based on your diary entries or mood. You can ask me about your diary, request movie recommendations, or tell me about your mood. How can I assist you today?',
        isBot: true,
      ));
    });
  }
}

  void _handleDiaryQuery(String query) {
    DiaryEntry? relevantEntry;
    if (query.toLowerCase().contains('latest')) {
      relevantEntry = _entries.isNotEmpty ? _entries.last : null;
    } else {
      relevantEntry = _entries.isNotEmpty ? _entries.last : null;
    }

    if (relevantEntry != null) {
      _askForConfirmationWithEntry(relevantEntry);
    } else {
      _askForMood();
    }
  }

  void _askForConfirmationWithEntry(DiaryEntry entry) {
    setState(() {
      _messages.add(ChatMessage(
        text: 'I found this diary entry:\n\n"${entry.content}"\n\nWould you like movie recommendations based on this? (Yes/No)',
        isBot: true,
      ));
      _waitingForConfirmation = true;
    });
  }

  void _provideRecommendations(String content) async {
    final recommendations = await _chatbotService.getRecommendations(content);
    setState(() {
      _messages.add(ChatMessage(
        text: 'Based on the diary entry, here are some movies you might enjoy:\n\n$recommendations\n\nFeel free to ask me anything about these movies or request more recommendations!',
        isBot: true,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _messages[_messages.length - 1 - index];
              },
            ),
          ),
          Divider(height: 1.0),
          Container(
            decoration: BoxDecoration(color: Theme.of(context).cardColor),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: TextField(
                      controller: _controller,
                      onSubmitted: _handleSubmitted,
                      decoration: InputDecoration(
                        hintText: 'Send a message',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () => _handleSubmitted(_controller.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isBot;

  ChatMessage({required this.text, required this.isBot});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              child: Icon(
                isBot ? Icons.android : Icons.person,
                color: Colors.white,
              ),
              backgroundColor: isBot ? Colors.deepPurple : Colors.blue,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(isBot ? 'Bot' : 'You',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  child: Text(text, style: GoogleFonts.poppins()),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}