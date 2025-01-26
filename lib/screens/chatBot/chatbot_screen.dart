import 'package:AgriGuide/local_database/database_helper.dart';
import 'package:AgriGuide/screens/chatBot/gemini_api_service.dart';
import 'package:AgriGuide/screens/chatBot/msg_bubble.dart';
import 'package:AgriGuide/screens/chatBot/msg_input.dart';
import 'package:AgriGuide/widgets/custom_widgets/threedot_animation.dart';
import 'package:flutter/material.dart';

class ChatbotScreen extends StatefulWidget {
  final String initialMessage;

  const ChatbotScreen({super.key, required this.initialMessage});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final List<Map<String, String>> _messages = [];
  final GeminiApiService _geminiApiService = GeminiApiService();
  final DatabaseHelper _databaseHelper = DatabaseHelper(); // Initialize DatabaseHelper
  bool _isLoading = false;
  final ScrollController _scrollController = ScrollController(); // Initialize ScrollController

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    final messages = await _databaseHelper.getMessages();
    setState(() {
      _messages.addAll(messages.map((msg) => {'sender': msg['sender'], 'message': msg['message']}));
      if (widget.initialMessage.isNotEmpty) {
        _sendMessage(widget.initialMessage);
      }
    });

    // Ensure scroll position is at the bottom
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _sendMessage(String message) async {
    FocusScope.of(context).unfocus();
    _scrollToBottom();
    setState(() {
      _messages.add({'sender': 'user', 'message': message});
      _isLoading = true;
      _scrollToBottom();
    });

    try {
      final botResponse = await _geminiApiService.getChatbotResponse("You are an agricultural chatbot - (AgriGuideBot) AGbot, $message");
      setState(() {
        _messages.add({'sender': 'bot', 'message': botResponse});
        _scrollToBottom();
      });
      await _databaseHelper.insertMessage(message, 'user');
      await _databaseHelper.insertMessage(botResponse, 'bot');
    } catch (error) {
      setState(() {
        _messages.add({'sender': 'bot', 'message': 'Oops! Something went wrong while storing messages. Please try again later.'});
        _scrollToBottom();
      });
    } finally {
      setState(() {
        _isLoading = false;
        _scrollToBottom();
      });
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AGbot',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.green,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.lightGreen, Color.fromARGB(255, 1, 128, 5)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Color(0xFFE0FFE5)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController, // Attach ScrollController
                itemCount: _messages.length + (_isLoading ? 1 : 0),
                itemBuilder: (ctx, index) {
                  if (_isLoading && index == _messages.length) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: ThreeDotLoader(),
                      ),
                    );
                  }

                  final message = _messages[index];
                  final isUserMessage = message['sender'] == 'user';
                  return MessageBubble(
                    message: message['message']!,
                    isUser: isUserMessage,
                  );
                },
              ),
            ),
            MessageInput(onSend: _sendMessage),
          ],
        ),
      ),
    );
  }
}
